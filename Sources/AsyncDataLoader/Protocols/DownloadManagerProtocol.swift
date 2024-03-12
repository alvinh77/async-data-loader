//
//  DownloadManagerProtocol.swift
//  AsyncDataLoader
//
//  Created by Alvin He on 12/3/2024.
//

import Foundation

/// A protocol representing a download manager for downloading data from URLs.
public protocol DownloadManagerProtocol: Sendable {
    /// Initiates a download operation from the specified URL.
    ///
    /// - Parameter url: The URL from which to download data.
    /// - Returns: An asynchronous stream of `DataStatus` values or an error.
    func download(from url: URL) -> AsyncThrowingStream<DataStatus, Error>
}
