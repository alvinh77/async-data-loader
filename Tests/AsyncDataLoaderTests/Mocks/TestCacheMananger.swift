//
//  TestCacheMananger.swift
//  AsyncDataLoader
//
//  Created by Alvin He on 5/3/2023.
//

import AsyncDataLoader
import Foundation

final class TestCacheMananger: CacheManagerProtocol {
    private(set) var objectCallCount = 0
    private(set) var setCallCount = 0
    private(set) var clearCacheCallCount = 0
    private(set) var objectKey: String?
    private(set) var setData: Data?
    private(set) var setKey: String?
    var data: Data?
    var error: Error?

    func object(forKey key: String) -> Data? {
        objectCallCount += 1
        objectKey = key
        return data
    }

    func set(_ data: Data, forKey key: String) throws {
        setCallCount += 1
        setData = data
        setKey = key
        if let error {
            throw error
        }
    }

    func clearCache() throws {
        clearCacheCallCount += 1
        if let error {
            throw error
        }
    }
}
