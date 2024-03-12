//
//  AsyncDataLoader.swift
//  AsyncDataLoader
//
//  Created by Alvin He on 23/2/2023.
//

import Foundation

public struct AsyncDataLoader: AsyncDataLoaderProtocol {
    private let diskCacheManager: CacheManagerProtocol
    private let downloadManager: DownloadManagerProtocol
    private let inMemoryCacheMananger: CacheManagerProtocol
    private let serverSession: ServerSessionProtocol

    public init(
        diskCacheManager: CacheManagerProtocol,
        downloadManager: DownloadManagerProtocol,
        inMemoryCacheMananger: CacheManagerProtocol,
        serverSession: ServerSessionProtocol
    ) {
        self.diskCacheManager = diskCacheManager
        self.downloadManager = downloadManager
        self.inMemoryCacheMananger = inMemoryCacheMananger
        self.serverSession = serverSession
    }

    public func data(from urlString: String) async throws -> Data {
        guard let url = URL(string: urlString) else { throw DataLoaderError.invalidURL }
        if let data = await inMemoryCacheMananger.object(forKey: urlString) { return data }
        if let data = await diskCacheManager.object(forKey: urlString) {
            try await inMemoryCacheMananger.set(data, forKey: urlString)
            return data
        }
        let (data, response) = try await serverSession.data(from: url)
        guard let statusCode = (response as? HTTPURLResponse)?.statusCode,
              (200...299).contains(statusCode) else { throw DataLoaderError.failedRequest }
        try await cache(data, forKey: urlString)
        return data
    }

    public func download(from urlString: String) async throws -> AsyncThrowingStream<DataStatus, Error> {
        guard let url = URL(string: urlString) else { throw DataLoaderError.invalidURL }
        if let data = await inMemoryCacheMananger.object(forKey: urlString) {
            return dataStatusStream(from: data)
        }
        if let data = await diskCacheManager.object(forKey: urlString) {
            try await inMemoryCacheMananger.set(data, forKey: urlString)
            return dataStatusStream(from: data)
        }
        return AsyncThrowingStream<DataStatus, Error> { continuation in
            let task = Task {
                for try await status in downloadManager.download(from: url) {
                    continuation.yield(status)
                    guard case let .finished(data) = status else { continue }
                    try await cache(data, forKey: urlString)
                }
                continuation.finish()
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
