//
//  ServerSession.swift
//  AsyncDataLoader
//
//  Created by Alvin He on 23/2/2023.
//

import Foundation

public protocol CacheManagerProtocol {
    func object(forKey key: String) async -> Data?
    func set(_ data: Data, forKey key: String) async throws
    func clearCache() async throws
}
