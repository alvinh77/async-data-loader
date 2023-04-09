//
//  TestServerSession.swift
//  AsyncDataLoader
//
//  Created by Alvin He on 5/3/2023.
//

import Foundation
import AsyncDataLoader

final class TestServerSession: ServerSessionProtocol {
    private(set) var dataCallCount = 0
    private(set) var bytesCallCount = 0
    var data = exampleData()
    var response = httpResponse(statusCode: 200)
    var stream = AsyncThrowingStream<UInt8, Error> { continuation in
        for _ in 0...9 {
            continuation.yield(10)
        }
        continuation.finish()
    }
    
    func data(from: URL) async throws -> (Data, URLResponse) {
        dataCallCount += 1
        return (data, response)
    }
    
    func bytes(from url: URL) async throws -> (AsyncThrowingStream<UInt8, Error>, URLResponse) {
        bytesCallCount += 1
        return (stream, response)
    }
    
    static func httpResponse(statusCode: Int) -> HTTPURLResponse {
        HTTPURLResponse(
            url: URL(string: "https://www.test.com")!,
            statusCode: statusCode,
            httpVersion: nil,
            headerFields: ["Content-Length": "10"]
        )!
    }

    static func exampleData() -> Data {
        var data = Data()
        (0...9).forEach { _ in data.append(UInt8(10)) }
        return data
    }
}
