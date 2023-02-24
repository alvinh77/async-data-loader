//
//  ServerSession.swift
//  AsyncDataLoader
//
//  Created by Alvin He on 23/2/2023.
//

import Foundation

public protocol ServerSessionProtocol {
    func data(from: URL) async throws -> (Data, URLResponse)
}

extension URLSession: ServerSessionProtocol {}
