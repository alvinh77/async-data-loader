//
//  ServerSession.swift
//  AsyncDataLoader
//
//  Created by Alvin He on 23/2/2023.
//

import Foundation

public protocol ServerSessionProtocol {
    func data(from: URL) async throws -> (Data, URLResponse)
    func bytes(from url: URL) async throws -> (AsyncThrowingStream<UInt8, Error>, URLResponse)
}

extension URLSession: ServerSessionProtocol {
    public func bytes(from url: URL) async throws -> (AsyncThrowingStream<UInt8, Error>, URLResponse) {
        let (bytes, response) = try await bytes(from: url, delegate: nil)
        let stream = AsyncThrowingStream<UInt8, Error> { continuation in
            Task {
                do {
                    for try await byte in bytes {
                        continuation.yield(byte)
                    }
                    continuation.finish()
                } catch {
                    continuation.finish(throwing: error)
                }
            }
        }
        return (stream, response)
    }
}
