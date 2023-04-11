//
//  TestDownloadManager.swift
//  AsyncDataLoader
//
//  Created by Alvin He on 5/3/2023.
//

import AsyncDataLoader
import Foundation

final class TestDownloadManager: DownloadManagerProtocol {
    private(set) var downloadCallCount = 0
    private(set) var url: URL?
    var dataStatus: [DataStatus] = [.inProgress(0.25), .inProgress(0.75)]
    var data = Data()
    var error: Error?

    func download(
        from url: URL
    ) -> AsyncThrowingStream<DataStatus, Error> {
        downloadCallCount += 1
        self.url = url
        return AsyncThrowingStream<DataStatus, Error> { continuation in
            for status in dataStatus {
                continuation.yield(status)
            }
            if error == nil {
                continuation.yield(.finished(data))
            }
            continuation.finish(throwing: error)
        }
    }
}
