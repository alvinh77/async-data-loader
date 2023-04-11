//
//  DownloadSessionFactory.swift
//  AsyncDataLoader
//
//  Created by Alvin He on 23/2/2023.
//

import Foundation

public protocol DownloadSessionFactoryProtocol {
    func makeSession(url: URL) -> DownloadSessionProtocol
}

public struct DownloadSessionFactory: DownloadSessionFactoryProtocol {
    private let serverSession: ServerSessionProtocol

    public init(serverSession: ServerSessionProtocol) {
        self.serverSession = serverSession
    }

    public func makeSession(url: URL) -> DownloadSessionProtocol {
        DownloadSession(url: url, serverSession: serverSession)
    }
}
