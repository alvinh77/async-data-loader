//
//  DownloadManager.swift
//  AsyncDataLoader
//
//  Created by Alvin He on 23/2/2023.
//

import Foundation

/// A protocol representing a download manager for downloading data from URLs.
public protocol DownloadManagerProtocol {
    /// Initiates a download operation from the specified URL.
    ///
    /// - Parameter url: The URL from which to download data.
    /// - Returns: An asynchronous stream of `DataStatus` values or an error.
    func download(from url: URL) -> AsyncThrowingStream<DataStatus, Error>
}

public final class DownloadManager: DownloadManagerProtocol {
    private let downloadSessionFactory: DownloadSessionFactoryProtocol
    // TODO: Replace this with a hash storage to make it more unit testable.
    private var downloadSessions: [URL: DownloadSessionProtocol] = [:]

    public init(downloadSessionFactory: DownloadSessionFactoryProtocol) {
        self.downloadSessionFactory = downloadSessionFactory
    }

    public func download(from url: URL) -> AsyncThrowingStream<DataStatus, Error> {
        let downloadSession = downloadSessionFactory.makeSession(url: url)
        downloadSessions[url] = downloadSession
        return downloadSession.downloadStream
    }
}
