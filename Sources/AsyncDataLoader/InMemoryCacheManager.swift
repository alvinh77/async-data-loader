//
//  ServerSession.swift
//  AsyncDataLoader
//
//  Created by Alvin He on 23/2/2023.
//

import Foundation

public final class InMemoryCacheManager: CacheManagerProtocol {

    private let cache: NSCache<WrappedKey, WrappedData>

    public init(cache: NSCache<WrappedKey, WrappedData>) {
        self.cache = cache
    }

    public func object(forKey key: String) -> Data? {
        cache.object(forKey: .init(key: key))?.data
    }

    public func set(_ data: Data, forKey key: String) {
        cache.setObject(.init(data: data), forKey: .init(key: key))
    }
}

extension InMemoryCacheManager {
    public final class WrappedKey: NSObject {
        private let key: String

        init(key: String) {
            self.key = key
        }

        public override var hash: Int { return key.hashValue }

        public override func isEqual(_ object: Any?) -> Bool {
            guard let value = object as? WrappedKey else {
                return false
            }
            return value.key == key
        }
    }

    public final class WrappedData {
        fileprivate let data: Data

        init(data: Data) {
            self.data = data
        }
    }
}
