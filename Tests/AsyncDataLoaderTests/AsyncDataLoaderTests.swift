//
//  AsyncDataLoaderTests.swift
//  AsyncDataLoader
//
//  Created by Alvin He on 23/2/2023.
//

import XCTest

@testable import AsyncDataLoader

final class AsyncDataLoaderTests: XCTestCase {
    private var dataLoader: AsyncDataLoader!
    private var diskCacheManager: TestCacheMananger!
    private var downloadManager: TestDownloadManager!
    private var inMemoryCacheManager: TestCacheMananger!
    private var serverSession: TestServerSession!

    override func setUp() {
        diskCacheManager = .init()
        downloadManager = .init()
        inMemoryCacheManager = .init()
        serverSession = .init()
        dataLoader = AsyncDataLoader(
            diskCacheManager: diskCacheManager,
            downloadManager: downloadManager,
            inMemoryCacheMananger: inMemoryCacheManager,
            serverSession: serverSession
        )
    }

    func test_retrieveData_whenURLIsInvalid() async throws {
        do {
            _ = try await dataLoader.data(from: "")
            XCTFail("An error is expected to be thrown")
        } catch {
            XCTAssertEqual(error as? DataLoaderError, .invalidURL)
        }
    }

    func test_retrieveData_whenCacheIsAvaiableInMemory() async throws {
        inMemoryCacheManager.data = Data()
        let data = try await dataLoader.data(from: "http://www.test.com")
        XCTAssertEqual(data, Data())
        XCTAssertEqual(inMemoryCacheManager.objectCallCount, 1)
        XCTAssertEqual(inMemoryCacheManager.objectKey, "http://www.test.com")
        XCTAssertEqual(diskCacheManager.objectCallCount, 0)
    }

    func test_retrieveData_whenCacheIsAvaiableInDisk() async throws {
        diskCacheManager.data = Data()
        let data = try await dataLoader.data(from: "http://www.test.com")
        XCTAssertEqual(data, Data())
        XCTAssertEqual(inMemoryCacheManager.objectCallCount, 1)
        XCTAssertEqual(inMemoryCacheManager.objectKey, "http://www.test.com")
        XCTAssertEqual(inMemoryCacheManager.setCallCount, 1)
        XCTAssertEqual(inMemoryCacheManager.setData, Data())
        XCTAssertEqual(inMemoryCacheManager.setKey, "http://www.test.com")
        XCTAssertEqual(diskCacheManager.objectCallCount, 1)
        XCTAssertEqual(diskCacheManager.objectKey, "http://www.test.com")
    }

    func test_retrieveData_whenCacheIsNotAvaiableAndRequestFailed() async throws {
        serverSession.response = TestServerSession.httpResponse(statusCode: 500)
        do {
            _ = try await dataLoader.data(from: "http://www.test.com")
            XCTFail("An error is expected to be thrown")
        } catch {
            XCTAssertEqual(serverSession.dataCallCount, 1)
            XCTAssertEqual(error as? DataLoaderError, .failedRequest)
        }
    }

    func test_retrieveData_whenCacheIsNotAvaiable() async throws {
        let data = try await dataLoader.data(from: "http://www.test.com")
        XCTAssertEqual(data, TestServerSession.exampleData())
        XCTAssertEqual(serverSession.dataCallCount, 1)
        XCTAssertEqual(inMemoryCacheManager.setCallCount, 1)
        XCTAssertEqual(inMemoryCacheManager.setData, TestServerSession.exampleData())
        XCTAssertEqual(inMemoryCacheManager.setKey, "http://www.test.com")
        XCTAssertEqual(diskCacheManager.setCallCount, 1)
        XCTAssertEqual(diskCacheManager.setData, TestServerSession.exampleData())
        XCTAssertEqual(diskCacheManager.setKey, "http://www.test.com")
    }

    func test_downloadData_whenURLIsInvalid_returnsError() async throws {
        do {
            _ = try await dataLoader.download(from: "")
        } catch {
            XCTAssertEqual(error as? DataLoaderError, .invalidURL)
        }
    }

    func test_downloadData_whenCacheIsAvaiableInMemory() async throws {
        inMemoryCacheManager.data = Data()
        let stream = try await dataLoader.download(from: "http://www.test.com")
        XCTAssertEqual(downloadManager.downloadCallCount, 0)
        var statusArray: [DataStatus] = []
        for try await status in stream {
            statusArray.append(status)
        }
        XCTAssertEqual(statusArray.count, 1)
        XCTAssertEqual(statusArray.last, .finished(Data()))
        XCTAssertEqual(inMemoryCacheManager.objectCallCount, 1)
        XCTAssertEqual(inMemoryCacheManager.objectKey, "http://www.test.com")
        XCTAssertEqual(diskCacheManager.objectCallCount, 0)
    }

    func test_downloadData_whenCacheIsAvaiableInDisk() async throws {
        diskCacheManager.data = Data()
        let stream = try await dataLoader.download(from: "http://www.test.com")
        XCTAssertEqual(downloadManager.downloadCallCount, 0)
        var statusArray: [DataStatus] = []
        for try await status in stream {
            statusArray.append(status)
        }
        XCTAssertEqual(statusArray.count, 1)
        XCTAssertEqual(statusArray.last, .finished(Data()))
        XCTAssertEqual(inMemoryCacheManager.objectCallCount, 1)
        XCTAssertEqual(inMemoryCacheManager.objectKey, "http://www.test.com")
        XCTAssertEqual(inMemoryCacheManager.setCallCount, 1)
        XCTAssertEqual(inMemoryCacheManager.setData, Data())
        XCTAssertEqual(inMemoryCacheManager.setKey, "http://www.test.com")
        XCTAssertEqual(diskCacheManager.objectCallCount, 1)
        XCTAssertEqual(diskCacheManager.objectKey, "http://www.test.com")
    }

    func test_downloadData_whenCacheIsNotAvaiable() async throws {
        let stream = try await dataLoader.download(from: "http://www.test.com")
        var statusArray: [DataStatus] = []
        for try await status in stream {
            statusArray.append(status)
        }
        XCTAssertEqual(
            statusArray,
            [
                .inProgress(0.25),
                .inProgress(0.75),
                .finished(downloadManager.data)
            ]
        )
        XCTAssertEqual(downloadManager.downloadCallCount, 1)
        XCTAssertEqual(downloadManager.url?.absoluteString, "http://www.test.com")
        XCTAssertEqual(inMemoryCacheManager.setCallCount, 1)
        XCTAssertEqual(inMemoryCacheManager.setData, downloadManager.data)
        XCTAssertEqual(inMemoryCacheManager.setKey, "http://www.test.com")
        XCTAssertEqual(diskCacheManager.setCallCount, 1)
        XCTAssertEqual(diskCacheManager.setData, downloadManager.data)
        XCTAssertEqual(diskCacheManager.setKey, "http://www.test.com")
    }

    func test_clearCache() async throws {
        try await dataLoader.clearCache()
        XCTAssertEqual(diskCacheManager.clearCacheCallCount, 1)
        XCTAssertEqual(inMemoryCacheManager.clearCacheCallCount, 1)
    }
}
