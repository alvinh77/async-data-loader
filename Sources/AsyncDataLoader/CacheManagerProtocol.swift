//
//  ServerSession.swift
//  AsyncDataLoader
//
//  Created by Alvin He on 23/2/2023.
//

import Foundation

/// A protocol representing a cache manager for storing and retrieving data.
public protocol CacheManagerProtocol {
    /// Retrieves the object associated with the specified key asynchronously.
    ///
    /// - Parameter key: The key to look up in the cache.
    /// - Returns: The data associated with the key, or `nil` if the key is not found.
    func object(forKey key: String) async -> Data?

    /// Sets the data for the specified key asynchronously.
    ///
    /// - Parameters:
    ///   - data: The data to store in the cache.
    ///   - key: The key with which to associate the data.
    /// - Throws: An error if the operation fails.
    func set(_ data: Data, forKey key: String) async throws

    /// Clears the cache asynchronously.
    ///
    /// - Throws: An error if the operation fails.
    func clearCache() async throws
}
