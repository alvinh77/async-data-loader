//
//  ServerSession.swift
//  AsyncDataLoader
//
//  Created by Alvin He on 23/2/2023.
//

import Foundation

public struct InMemoryCacheManager: CacheManagerProtocol {

    private let cache: NSCache<NSString, WrappedData>

    public init(cache: NSCache<NSString, WrappedData>) {
        self.cache = cache
    }

    public func object(forKey key: String) -> Data? {
        cache.object(forKey: NSString(string: key))?.data
    }

    public func set(_ data: Data, forKey key: String) throws {
        cache.setObject(.init(data: data), forKey: NSString(string: key))
    }

    public func clearCache() {
        cache.removeAllObjects()
    }
}

extension InMemoryCacheManager {
    public final class WrappedData {
        fileprivate let data: Data

        init(data: Data) {
            self.data = data
        }
    }
}

extension NSCache: @unchecked Sendable {}
