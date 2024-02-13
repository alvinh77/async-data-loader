//
//  TestDownloadSession.swift
//  AsyncDataLoader
//
//  Created by Alvin He on 5/3/2023.
//

import AsyncDataLoader
import Foundation

typealias DownloadStream = AsyncThrowingStream<DataStatus, Error>
typealias Continuation = DownloadStream.Continuation

final class TestDownloadSession: DownloadSessionProtocol {
    private(set) var continuation: Continuation?
    private(set) lazy var downloadStream: DownloadStream = {
        .init { [weak self] continuation in
            self?.continuation = continuation
        }
    }()
}
