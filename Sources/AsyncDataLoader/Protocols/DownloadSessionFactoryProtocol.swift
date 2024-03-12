//
//  DownloadSessionFactoryProtocol.swift
//  AsyncDataLoader
//
//  Created by Alvin He on 12/3/2024.
//

import Foundation

public protocol DownloadSessionFactoryProtocol {
    func makeSession(url: URL) -> DownloadSessionProtocol
}
