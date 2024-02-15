//
//  InMemoryCacheManagerTests.swift
//  AsyncDataLoader
//
//  Created by Alvin He on 5/3/2023.
//

import XCTest

@testable import AsyncDataLoader

final class InMemoryCacheManagerTests: XCTestCase {
    func test_retrieveAndSetObjects() async throws {
        let inMemoryCacheManager = InMemoryCacheManager(cache: .init())

        let nilData = await inMemoryCacheManager.object(forKey: "testKey")
        XCTAssertNil(nilData)

        let inputData = "testData".data(using: .utf8)!
        _ = try await inMemoryCacheManager.set(inputData, forKey: "testKey")
        let outputData = await inMemoryCacheManager.object(forKey: "testKey")
        XCTAssertEqual(outputData, inputData)
    }

    func test_clearCache() async throws {
        let inMemoryCacheManager = InMemoryCacheManager(cache: .init())

        _ = try await inMemoryCacheManager.set("testData".data(using: .utf8)!, forKey: "testKey")
        _ = await inMemoryCacheManager.clearCache()
        let outputData = await inMemoryCacheManager.object(forKey: "testKey")
        XCTAssertNil(outputData)
    }
}
