//
//  DownloadSessionFactoryTests.swift
//  AsyncDataLoader
//
//  Created by Alvin He on 14/2/2024.
//

import XCTest

@testable import AsyncDataLoader

final class DownloadSessionFactoryTests: XCTestCase {
    func test_makeSession_returnsDownloadSession() throws {
        let factory = DownloadSessionFactory(serverSession: TestServerSession())
        let url = try XCTUnwrap(URL(string: "https:\\www.google.com"))
        XCTAssertTrue(factory.makeSession(url: url) is DownloadSession)
    }
}
