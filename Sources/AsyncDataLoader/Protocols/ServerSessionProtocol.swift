//
//  ServerSession.swift
//  AsyncDataLoader
//
//  Created by Alvin He on 23/2/2023.
//

import Foundation

/// A protocol representing a session for interacting with a server.
public protocol ServerSessionProtocol: Sendable {
    /// Asynchronously retrieves the contents of the specified URL.
    ///
    /// - Parameters:
    ///   - url: The URL to retrieve data from.
    /// - Returns: A tuple containing the retrieved data and the response.
    /// - Throws: An error if the operation fails.
    func data(from url: URL) async throws -> (Data, URLResponse)

    /// Initiates a download task for the specified URL.
    ///
    /// - Parameters:
    ///   - url: The URL to download from.
    /// - Returns: A task representing the download operation.
    func download(from url: URL) -> DownloadTask
}

/// A protocol representing a download task.
public protocol DownloadTask: Sendable {
    /// The delegate to handle various task events.
    var delegate: URLSessionTaskDelegate? { get set }

    /// Resumes the download task.
    func resume()

    /// Cancels the download task.
    func cancel()
}

extension URLSessionDownloadTask: DownloadTask {}

extension URLSession: ServerSessionProtocol {
    public func download(from url: URL) -> DownloadTask {
        downloadTask(with: .init(url: url))
    }
}
