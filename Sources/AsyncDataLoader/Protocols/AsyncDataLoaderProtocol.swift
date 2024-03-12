//
//  AsyncDataLoaderProtocol.swift
//  AsyncDataLoader
//
//  Created by Alvin He on 12/3/2024.
//

import Foundation

public protocol AsyncDataLoaderProtocol: Sendable {
    func data(from urlString: String) async throws -> Data
    func download(from urlString: String) async throws -> AsyncThrowingStream<DataStatus, Error>
    func clearCache() async throws
}
