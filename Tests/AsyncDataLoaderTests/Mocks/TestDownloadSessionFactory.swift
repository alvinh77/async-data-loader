//
//  TestDownloadSessionFactory.swift
//  AsyncDataLoader
//
//  Created by Alvin He on 5/3/2023.
//

import AsyncDataLoader
import Foundation

final class TestDownloadSessionFactory: DownloadSessionFactoryProtocol {
    private(set) var makeSessionCalls: [URL] = []
    let testDownloadSession: TestDownloadSession

    init(testDownloadSession: TestDownloadSession = .init()) {
        self.testDownloadSession = testDownloadSession
    }

    func makeSession(url: URL) -> DownloadSessionProtocol {
        makeSessionCalls.append(url)
        return testDownloadSession
    }
}
