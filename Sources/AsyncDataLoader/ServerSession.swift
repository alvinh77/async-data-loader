//
//  ServerSession.swift
//  AsyncDataLoader
//
//  Created by Alvin He on 23/2/2023.
//

import Foundation

public protocol ServerSessionProtocol {
    func data(from url: URL) async throws -> (Data, URLResponse)
    func download(from url: URL) -> DownloadTask
}

public protocol DownloadTask {
    var delegate: URLSessionTaskDelegate? { get set }
    func resume()
    func cancel()
}

extension URLSessionDownloadTask: DownloadTask {}

extension URLSession: ServerSessionProtocol {
    public func download(from url: URL) -> DownloadTask {
        downloadTask(with: .init(url: url))
    }
}
