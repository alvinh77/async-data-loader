//
//  DownloadSession.swift
//  AsyncDataLoader
//
//  Created by Alvin He on 23/2/2023.
//

import Foundation

public protocol DownloadSessionProtocol {
    var downloadStream: AsyncThrowingStream<DataStatus, Error> { get }
}

public final class DownloadSession: NSObject, DownloadSessionProtocol {
    private let url: URL
    private let serverSession: ServerSessionProtocol
    private let dataProvider: (URL) -> Data?
    private var continuation: AsyncThrowingStream<DataStatus, Error>.Continuation?
    private lazy var task: DownloadTask = {
        var task = serverSession.download(from: self.url)
        task.delegate = self
        return task
    }()

    private(set) public lazy var downloadStream: AsyncThrowingStream<DataStatus, Error> = {
        AsyncThrowingStream<DataStatus, Error> { [weak self] continuation in
            self?.continuation = continuation
            self?.task.resume()
            continuation.onTermination = { @Sendable [weak self] _ in
                self?.task.cancel()
            }
        }
    }()

    public init(
        url: URL,
        serverSession: ServerSessionProtocol,
        dataProvider: @escaping (URL) -> Data? = { try? Data(contentsOf: $0) }
    ) {
        self.url = url
        self.serverSession = serverSession
        self.dataProvider = dataProvider
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
        continuation?.yield(.inProgress(Double(totalBytesWritten) / Double(totalBytesExpectedToWrite)))
    }

    public func urlSession(
        _ session: URLSession,
        downloadTask: URLSessionDownloadTask,
        didFinishDownloadingTo location: URL
    ) {
        guard let data = dataProvider(location) else {
            continuation?.finish(throwing: DataLoaderError.dataNotFound)
            return
        }
        continuation?.yield(.finished(data))
        continuation?.finish()
    }
}
