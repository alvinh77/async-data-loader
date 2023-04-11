//
//  DownloadManager.swift
//  AsyncDataLoader
//
//  Created by Alvin He on 23/2/2023.
//

import Foundation

public protocol DownloadManagerProtocol {
    func download(from url: URL) -> AsyncThrowingStream<DataStatus, Error>
}

public final class DownloadManager: DownloadManagerProtocol {
    private let downloadSessionFactory: DownloadSessionFactoryProtocol
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
