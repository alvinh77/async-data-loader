//
//  AsyncDataLoader.swift
//  AsyncDataLoader
//
//  Created by Alvin He on 23/2/2023.
//

import Foundation

public protocol AsyncDataLoaderProtocol {
    func data(from url: String) async throws -> Data
}

public struct AsyncDataLoader: AsyncDataLoaderProtocol {

    private let diskCacheManager: CacheManagerProtocol
    private let inMemoryCacheMananger: CacheManagerProtocol
    private let severSession: ServerSessionProtocol

    public init(
        diskCacheManager: CacheManagerProtocol,
        inMemoryCacheMananger: CacheManagerProtocol,
        severSession: ServerSessionProtocol
    ) {
        self.diskCacheManager = diskCacheManager
        self.inMemoryCacheMananger = inMemoryCacheMananger
        self.severSession = severSession
    }

    public func data(from url: String) async throws -> Data {
        if let data = await inMemoryCacheMananger.object(forKey: url) { return data }
        if let data = await diskCacheManager.object(forKey: url) { return data }
        guard let url = URL(string: url) else { throw DataLoaderError.invalidURL }
        let (data, _) = try await severSession.data(from: url)
        _ = try await (
            inMemoryCacheMananger.set(data, forKey: url.absoluteString),
            diskCacheManager.set(data, forKey: url.absoluteString)
        )
        return data
    }
}
