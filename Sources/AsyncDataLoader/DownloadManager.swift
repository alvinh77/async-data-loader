//
//  DownloadManager.swift
//  AsyncDataLoader
//
//  Created by Alvin He on 23/2/2023.
//

import Foundation

public final class DownloadManager: DownloadManagerProtocol {
    private let downloadSessionFactory: DownloadSessionFactoryProtocol
    // notaTODO: Replace this with a hash storage to make it more unit testable.
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
