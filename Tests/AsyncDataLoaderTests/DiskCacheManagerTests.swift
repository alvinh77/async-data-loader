//
//  DiskCacheManagerTests.swift
//  AsyncDataLoader
//
//  Created by Alvin He on 5/3/2023.
//

import XCTest

@testable import AsyncDataLoader

final class DiskCacheManagerTests: XCTestCase {
    func test_retrieveObject() throws {
        let dependency = TestFileManager()
        let fileManager = DiskCacheManager(fileMananger: dependency)

        _ = fileManager.object(forKey: "TestKey")

        XCTAssertEqual(dependency.urlsCalledCount, 1)
        XCTAssertEqual(dependency.urlsCalledParams?.directory, .cachesDirectory)
        XCTAssertEqual(dependency.urlsCalledParams?.domainMask, .userDomainMask)
        XCTAssertEqual(dependency.contentsCalledCount, 1)
        XCTAssertEqual(dependency.contentsCalledParams, "/Users/tester/Caches/ImageCache/4171614418690781136")
    }

    func test_retrieveObject_whenCacheDirectoryDoesNotExist() throws {
        let dependency = TestFileManager(urls: [])
        let fileManager = DiskCacheManager(fileMananger: dependency)
        let object = fileManager.object(forKey: "TestKey")

        XCTAssertNil(object)
        XCTAssertEqual(dependency.urlsCalledCount, 1)
        XCTAssertEqual(dependency.urlsCalledParams?.directory, .cachesDirectory)
        XCTAssertEqual(dependency.urlsCalledParams?.domainMask, .userDomainMask)
        XCTAssertEqual(dependency.contentsCalledCount, 0)
    }

    func test_setObject_whenCacheDirectoryDoesNotExist() throws {
        let dependency = TestFileManager(urls: [])
        let fileManager = DiskCacheManager(fileMananger: dependency)

        try fileManager.set("TestData".data(using: .utf8)!, forKey: "TestKey")

        XCTAssertEqual(dependency.urlsCalledCount, 1)
        XCTAssertEqual(dependency.urlsCalledParams?.directory, .cachesDirectory)
        XCTAssertEqual(dependency.urlsCalledParams?.domainMask, .userDomainMask)
        XCTAssertEqual(dependency.fileExistsCalledCount, 0)
        XCTAssertEqual(dependency.createFileCalledCount, 0)
    }

    func test_setObject() throws {
        let dependency = TestFileManager()
        let fileManager = DiskCacheManager(fileMananger: dependency)

        try fileManager.set("TestData".data(using: .utf8)!, forKey: "TestKey")

        XCTAssertEqual(dependency.urlsCalledCount, 1)
        XCTAssertEqual(dependency.urlsCalledParams?.directory, .cachesDirectory)
        XCTAssertEqual(dependency.urlsCalledParams?.domainMask, .userDomainMask)
        XCTAssertEqual(dependency.fileExistsCalledCount, 1)
        XCTAssertEqual(dependency.fileExistsCalledParams, "/Users/tester/Caches/ImageCache")
        XCTAssertEqual(dependency.createFileCalledCount, 1)
        XCTAssertEqual(dependency.createFileCalledParam?.path, "/Users/tester/Caches/ImageCache/4171614418690781136")
        XCTAssertEqual(dependency.createFileCalledParam?.data, "TestData".data(using: .utf8))
        XCTAssertNil(dependency.createFileCalledParam?.attr)
    }

    func test_clearCache() throws {
        let dependency = TestFileManager()
        let fileManager = DiskCacheManager(fileMananger: dependency)

        try fileManager.clearCache()

        XCTAssertEqual(dependency.removeItemCalledCount, 1)
        XCTAssertEqual(dependency.removeItemCalledParam?.absoluteString, "file:///Users/tester/Caches/ImageCache")
    }

    func test_clearCache_whenCacheDirectoryDoesNotExist() throws {
        let dependency = TestFileManager(urls: [])
        let fileManager = DiskCacheManager(fileMananger: dependency)
        try fileManager.clearCache()

        XCTAssertEqual(dependency.removeItemCalledCount, 0)
    }
}
