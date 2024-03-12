//
//  DownloadManager.swift
//  AsyncDataLoader
//
//  Created by Alvin He on 23/2/2023.
//

import Foundation

public struct DownloadManager: DownloadManagerProtocol {
    private let downloadSessionFactory: DownloadSessionFactoryProtocol

    public init(downloadSessionFactory: DownloadSessionFactoryProtocol) {
        self.downloadSessionFactory = downloadSessionFactory
    }

    public func download(from url: URL) -> AsyncThrowingStream<DataStatus, Error> {
        let downloadSession = downloadSessionFactory.makeSession(url: url)
        return downloadSession.downloadStream
    }
}
