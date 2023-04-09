//
//  ServerSession.swift
//  AsyncDataLoader
//
//  Created by Alvin He on 23/2/2023.
//

import Foundation

public actor DiskCacheManager: CacheManagerProtocol {

    private let fileMananger: FileManagerProtocol

    public init(fileMananger: FileManagerProtocol) {
        self.fileMananger = fileMananger
    }

    public func object(forKey key: String) -> Data? {
        guard let filePath = getFilePath(forKey: key)?.path else { return nil }
        return fileMananger.contents(atPath: filePath)
    }

    public func set(_ data: Data, forKey key: String) throws {
        guard let cacheDirectory else { return }
        if !fileMananger.fileExists(atPath: cacheDirectory.path) {
            try fileMananger.createDirectory(
                at: cacheDirectory,
                withIntermediateDirectories: true,
                attributes: nil
            )
        }
        guard let filePath = getFilePath(forKey: key)?.path else { return }
        _ = fileMananger.createFile(atPath: filePath, contents: data, attributes: nil)
    }

    public func clearCache() throws {
        guard let cacheDirectory else { return }
        try fileMananger.removeItem(at: cacheDirectory)
    }

    private var cacheDirectory: URL? {
        fileMananger.urls(
            for: .cachesDirectory,
            in: .userDomainMask
        ).first?.appendingPathComponent("ImageCache")
    }

    private func getFilePath(forKey key: String) -> URL? {
        cacheDirectory?.appendingPathComponent("\(key.hash)")
    }
}
