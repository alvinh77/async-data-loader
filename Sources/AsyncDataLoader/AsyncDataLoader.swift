//
//  AsyncDataLoader.swift
//  AsyncDataLoader
//
//  Created by Alvin He on 23/2/2023.
//

import Foundation

public protocol AsyncDataLoaderProtocol {
    func data(from url: String) async throws -> Data
}

public struct AsyncDataLoader: AsyncDataLoaderProtocol {

    private let severSession: ServerSessionProtocol

    public init(severSession: ServerSessionProtocol) {
        self.severSession = severSession
    }

    public func data(from url: String) async throws -> Data {
        guard let url = URL(string: url) else { throw DataLoaderError.invalidURL }
        let (data, _) = try await severSession.data(from: url)
        return data
    }
}
