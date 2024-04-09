//
//  DownloadSession.swift
//  AsyncDataLoader
//
//  Created by Alvin He on 23/2/2023.
//

import Foundation

public final class DownloadSession: NSObject, DownloadSessionProtocol {
    private let serverSession: ServerSessionProtocol
    private let dataProvider: (URL) -> Data?
    private let continuation: AsyncThrowingStream<DataStatus, Error>.Continuation
    private let task: DownloadTask
    public let downloadStream: AsyncThrowingStream<DataStatus, Error>

    public init(
        url: URL,
        serverSession: ServerSessionProtocol,
        dataProvider: @escaping (URL) -> Data? = { try? Data(contentsOf: $0) }
    ) {
        self.serverSession = serverSession
        self.dataProvider = dataProvider
        let (stream, continuation) = AsyncThrowingStream<DataStatus, Error>.makeStream()
        self.downloadStream = stream
        self.continuation = continuation
        var task = serverSession.download(from: url)
        self.task = task
        super.init()
        task.delegate = self
        task.resume()
    }
}

// MARK: - URLSessionDownloadDelegate

extension DownloadSession: URLSessionDownloadDelegate {
    public func urlSession(
        _ session: URLSession,
        downloadTask: URLSessionDownloadTask,
        didWriteData bytesWritten: Int64,
        totalBytesWritten: Int64,
        totalBytesExpectedToWrite: Int64
    ) {
        continuation.yield(.inProgress(Double(totalBytesWritten) / Double(totalBytesExpectedToWrite)))
    }

    public func urlSession(
        _ session: URLSession,
        downloadTask: URLSessionDownloadTask,
        didFinishDownloadingTo location: URL
    ) {
        guard let data = dataProvider(location) else {
            continuation.finish(throwing: DataLoaderError.dataNotFound)
            return
        }
        continuation.yield(.finished(data))
        continuation.finish()
    }
}
