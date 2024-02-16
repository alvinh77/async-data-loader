//
//  DownloadSessionTests.swift
//  AsyncDataLoader
//
//  Created by Alvin He on 14/2/2024.
//

import XCTest

@testable import AsyncDataLoader

final class DownloadSessionTests: XCTestCase {
    func test_downloadStream_whenReceiveProgressAndFinish() async throws {
        let url = try XCTUnwrap(URL(string: "https://www.test.com"))
        let downloadSession = DownloadSession(
            url: url,
            serverSession: TestServerSession(),
            dataProvider: { _ in Data(count: 10) }
        )
        let downloadStream = downloadSession.downloadStream
        let urlSession = URLSession(configuration: .ephemeral)
        let request = URLRequest(url: url)
        let downloadTask = urlSession.downloadTask(with: request)
        downloadSession.urlSession(
            urlSession,
            downloadTask: downloadTask,
            didWriteData: 10,
            totalBytesWritten: 15,
            totalBytesExpectedToWrite: 30
        )
        downloadSession.urlSession(
            urlSession,
            downloadTask: downloadTask,
            didFinishDownloadingTo: url
        )
        var statuses = [DataStatus]()
        for try await status in downloadStream {
            statuses.append(status)
        }

        XCTAssertEqual(
            statuses,
            [.inProgress(0.5), .finished(Data(count: 10))]
        )
    }

    func test_downloadStream_whenFinishButCouldNotFindData() async throws {
        let url = try XCTUnwrap(URL(string: "file:///Users"))
        let downloadSession = DownloadSession(
            url: url,
            serverSession: TestServerSession()
        )
        let downloadStream = downloadSession.downloadStream
        let urlSession = URLSession(configuration: .ephemeral)
        let request = URLRequest(url: url)
        let downloadTask = urlSession.downloadTask(with: request)
        downloadSession.urlSession(
            urlSession,
            downloadTask: downloadTask,
            didFinishDownloadingTo: url
        )
        var statuses = [DataStatus]()
        do {
            for try await status in downloadStream {
                statuses.append(status)
            }
        } catch {
            XCTAssertEqual(error as? DataLoaderError, .dataNotFound)
        }

        XCTAssertEqual(statuses.count, 0)
    }
}
