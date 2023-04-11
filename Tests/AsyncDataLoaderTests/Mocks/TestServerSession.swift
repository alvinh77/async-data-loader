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
    private(set) var downloadCallCount = 0
    private(set) var url: URL?
    var data = exampleData()
    var response = httpResponse(statusCode: 200)
    var stream = AsyncThrowingStream<UInt8, Error> { continuation in
        for _ in 0...9 {
            continuation.yield(10)
        }
        continuation.finish()
    }
    
    func data(from url: URL) async throws -> (Data, URLResponse) {
        dataCallCount += 1
        self.url = url
        return (data, response)
    }

    func download(from url: URL) -> DownloadTask {
        downloadCallCount += 1
        self.url = url
        return TestDownloadTask()
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
