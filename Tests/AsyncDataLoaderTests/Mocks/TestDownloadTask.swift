//
//  TestDownloadTask.swift
//  AsyncDataLoader
//
//  Created by Alvin He on 5/3/2023.
//

import AsyncDataLoader
import Foundation

final class TestDownloadTask: DownloadTask {
    private(set) var resumeCallCount = 0
    private(set) var cancelCallCount = 0
    var delegate: URLSessionTaskDelegate?

    func resume() {
        resumeCallCount += 1
    }

    func cancel() {
        cancelCallCount += 1
    }
}
