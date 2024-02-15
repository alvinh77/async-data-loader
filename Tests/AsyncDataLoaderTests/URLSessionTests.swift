//
//  URLSessionTests.swift
//  AsyncDataLoader
//
//  Created by Alvin He on 15/2/2024.
//

import XCTest

@testable import AsyncDataLoader

final class URLSessionTests: XCTestCase {
    func test_download_returnsDownloadTask() throws {
        let session = URLSession(configuration: .ephemeral)
        let url = try XCTUnwrap(URL(string: "https:\\www.google.com"))
        let downloadTask = session.download(from: url)
        XCTAssertTrue(downloadTask is URLSessionDownloadTask)
    }
}
