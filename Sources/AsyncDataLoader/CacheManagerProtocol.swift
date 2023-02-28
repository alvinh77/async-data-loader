//
//  ServerSession.swift
//  AsyncDataLoader
//
//  Created by Alvin He on 23/2/2023.
//

import Foundation

public protocol CacheManagerProtocol: Actor {
    func object(forKey key: String) -> Data?
    func set(_ data: Data, forKey key: String) throws
    func clearCache() throws
}
