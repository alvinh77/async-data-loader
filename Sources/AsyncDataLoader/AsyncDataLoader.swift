//
//  AsyncDataLoader.swift
//  AsyncDataLoader
//
//  Created by Alvin He on 23/2/2023.
//

import Foundation

public protocol AsyncDataLoaderProtocol {
    func data(from url: String) async throws -> Data
    func download(from url: String) async throws -> AsyncThrowingStream<DataStatus, Error>
    func clearCache() async throws
}

public struct AsyncDataLoader: AsyncDataLoaderProtocol {

    private let diskCacheManager: CacheManagerProtocol
    private let inMemoryCacheMananger: CacheManagerProtocol
    private let serverSession: ServerSessionProtocol

    public init(
        diskCacheManager: CacheManagerProtocol,
        inMemoryCacheMananger: CacheManagerProtocol,
        serverSession: ServerSessionProtocol
    ) {
        self.diskCacheManager = diskCacheManager
        self.inMemoryCacheMananger = inMemoryCacheMananger
        self.serverSession = serverSession
    }

    public func data(from url: String) async throws -> Data {
        guard let url = URL(string: url) else { throw DataLoaderError.invalidURL }
        if let data = await inMemoryCacheMananger.object(forKey: url.absoluteString) { return data }
        if let data = await diskCacheManager.object(forKey: url.absoluteString) {
            try await inMemoryCacheMananger.set(data, forKey: url.absoluteString)
            return data
        }
        let (data, response) = try await serverSession.data(from: url)
        guard let statusCode = (response as? HTTPURLResponse)?.statusCode,
              (200...299).contains(statusCode) else { throw DataLoaderError.failedRequest }
        try await cache(data, forKey: url.absoluteString)
        return data
    }

    public func download(from url: String) async throws -> AsyncThrowingStream<DataStatus, Error> {
        guard let url = URL(string: url) else { throw DataLoaderError.invalidURL }
        if let data = await inMemoryCacheMananger.object(forKey: url.absoluteString) {
            return dataStatusStream(from: data)
        }
        if let data = await diskCacheManager.object(forKey: url.absoluteString) {
            try await inMemoryCacheMananger.set(data, forKey: url.absoluteString)
            return dataStatusStream(from: data)
        }
        let (bytes, response) = try await serverSession.bytes(from: url)
        guard let statusCode = (response as? HTTPURLResponse)?.statusCode,
              (200...299).contains(statusCode) else { throw DataLoaderError.failedRequest }
        let dataSize = response.expectedContentLength
        return AsyncThrowingStream<DataStatus, Error> { continuation in
            let task = Task {
                do {
                    var data = Data()
                    var currentSize = 0
                    var currentPercent = 0
                    for try await byte in bytes {
                        data.append(byte)
                        currentSize += 1
                        let newProgress = Double(currentSize) / Double(dataSize)
                        let newPercent = Int(newProgress * 100)
                        guard newPercent > currentPercent else { continue }
                        currentPercent = newPercent
                        continuation.yield(.inProgress(newProgress))
                        print("continuation.yield(.inProgress(\(newProgress))")
                    }
                    continuation.yield(.finished(data))
                    try await cache(data, forKey: url.absoluteString)
                    continuation.finish()
                } catch {
                    continuation.finish(throwing: error)
                }
            }
            continuation.onTermination = { _ in task.cancel() }
        }
    }

    public func clearCache() async throws {
        _ = try await (
            inMemoryCacheMananger.clearCache(),
            diskCacheManager.clearCache()
        )
    }
}

// MARK: - Helper

extension AsyncDataLoader {
    private func dataStatusStream(from data: Data) -> AsyncThrowingStream<DataStatus, Error> {
        AsyncThrowingStream<DataStatus, Error> { continuation in
            continuation.yield(.finished(data))
            continuation.finish()
        }
    }

    private func cache(_ data: Data, forKey: String) async throws {
        _ = try await (
            inMemoryCacheMananger.set(data, forKey: forKey),
            diskCacheManager.set(data, forKey: forKey)
        )
    }
}
