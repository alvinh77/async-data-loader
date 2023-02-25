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

    private let inMemoryCache: InMemoryCacheProtocol
    private let severSession: ServerSessionProtocol

    public init(
        inMemoryCache: InMemoryCacheProtocol,
        severSession: ServerSessionProtocol
    ) {
        self.inMemoryCache = inMemoryCache
        self.severSession = severSession
    }

    public func data(from url: String) async throws -> Data {
        if let data = inMemoryCache.object(forKey: url) { return data }
        guard let url = URL(string: url) else { throw DataLoaderError.invalidURL }
        let (data, _) = try await severSession.data(from: url)
        inMemoryCache.set(data, forKey: url.absoluteString)
        return data
    }
}
