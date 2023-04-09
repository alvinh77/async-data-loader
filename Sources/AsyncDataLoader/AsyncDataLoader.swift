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

public enum DataStatus: Sendable {
    case inProgress(Int)
    case finished(Data)
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
        if let data = await inMemoryCacheMananger.object(forKey: url) { return data }
        if let data = await diskCacheManager.object(forKey: url) {
            try await inMemoryCacheMananger.set(data, forKey: url)
            return data
        }
        guard let url = URL(string: url) else { throw DataLoaderError.invalidURL }
        let (data, response) = try await serverSession.data(from: url)
        guard let statusCode = (response as? HTTPURLResponse)?.statusCode,
              (200...299).contains(statusCode) else { throw DataLoaderError.failedRequest }
        _ = try await (
            inMemoryCacheMananger.set(data, forKey: url.absoluteString),
            diskCacheManager.set(data, forKey: url.absoluteString)
        )
        return data
    }

    public func download(from url: String) async throws -> AsyncThrowingStream<DataStatus, Error> {
        guard let url = URL(string: url) else { throw DataLoaderError.invalidURL }
        let (bytes, response) = try await serverSession.bytes(from: url)
        guard let statusCode = (response as? HTTPURLResponse)?.statusCode,
              (200...299).contains(statusCode) else { throw DataLoaderError.failedRequest }
        let dataSize = response.expectedContentLength
        return AsyncThrowingStream<DataStatus, Error> { continuation in
            Task {
                do {
                    var data = Data()
                    var progress = 0
                    for try await byte in bytes {
                        data.append(byte)
                        let newProgress = Int(Double(data.count) * 100 / Double(dataSize))
                        guard newProgress > progress else { continue }
                        progress = newProgress
                        continuation.yield(.inProgress(progress))
                        guard progress == 100 else { continue }
                    }
                    continuation.yield(.finished(data))
                    continuation.finish()
                } catch {
                    continuation.finish(throwing: error)
                }
            }
        }
    }

    public func clearCache() async throws {
        _ = try await (
            inMemoryCacheMananger.clearCache(),
            diskCacheManager.clearCache()
        )
    }
}
