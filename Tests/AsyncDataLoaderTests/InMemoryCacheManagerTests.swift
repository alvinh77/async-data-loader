//
//  InMemoryCacheManagerTests.swift
//  AsyncDataLoader
//
//  Created by Alvin He on 5/3/2023.
//

import XCTest

@testable import AsyncDataLoader

final class InMemoryCacheManagerTests: XCTestCase {
    func test_retrieveAndSetObjects() throws {
        let inMemoryCacheManager = InMemoryCacheManager(cache: .init())

        let nilData = inMemoryCacheManager.object(forKey: "testKey")
        XCTAssertNil(nilData)

        let inputData = "testData".data(using: .utf8)!
        try inMemoryCacheManager.set(inputData, forKey: "testKey")
        let outputData = inMemoryCacheManager.object(forKey: "testKey")
        XCTAssertEqual(outputData, inputData)
    }

    func test_clearCache() async throws {
        let inMemoryCacheManager = InMemoryCacheManager(cache: .init())

        try inMemoryCacheManager.set("testData".data(using: .utf8)!, forKey: "testKey")
        inMemoryCacheManager.clearCache()
        let outputData = inMemoryCacheManager.object(forKey: "testKey")
        XCTAssertNil(outputData)
    }
}
