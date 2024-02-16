//
//  DownloadManagerTests.swift
//  AsyncDataLoader
//
//  Created by Alvin He on 14/2/2024.
//

import XCTest

@testable import AsyncDataLoader

final class DownloadManagerTests: XCTestCase {
    func test_download_returnsAsyncThrowingStream() async throws {
        let downloadSessionFactory = TestDownloadSessionFactory()
        let manager = DownloadManager(downloadSessionFactory: downloadSessionFactory)
        let url = try XCTUnwrap(URL(string: "https:\\www.google.com"))
        let downloadStream = manager.download(from: url)
        var dataStatuses: [DataStatus] = []
        let continuation = downloadSessionFactory.testDownloadSession.continuation
        continuation?.yield(with: .success(.inProgress(1)))
        continuation?.finish()
        for try await dataStatus in downloadStream {
            dataStatuses.append(dataStatus)
        }

        XCTAssertEqual(dataStatuses, [.inProgress(1)])
    }
}
