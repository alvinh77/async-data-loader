//
//  ServerSession.swift
//  AsyncDataLoader
//
//  Created by Alvin He on 23/2/2023.
//

import Foundation

public actor InMemoryCacheManager: CacheManagerProtocol {

    private let cache: NSCache<WrappedKey, WrappedData>

    public init(cache: NSCache<WrappedKey, WrappedData>) {
        self.cache = cache
    }

    public func object(forKey key: String) -> Data? {
        cache.object(forKey: .init(key: key))?.data
    }

    public func set(_ data: Data, forKey key: String) throws {
        cache.setObject(.init(data: data), forKey: .init(key: key))
    }

    public func clearCache() {
        cache.removeAllObjects()
    }
}

extension InMemoryCacheManager {
    public final class WrappedKey {
        private let key: String

        init(key: String) {
            self.key = key
        }
    }

    public final class WrappedData {
        fileprivate let data: Data

        init(data: Data) {
            self.data = data
        }
    }
}

extension NSCache: @unchecked Sendable {}
