//
//  TestFileManager.swift
//  AsyncDataLoader
//
//  Created by Alvin He on 5/3/2023.
//

import AsyncDataLoader
import Foundation

final class TestFileManager: FileManagerProtocol, @unchecked Sendable {
    typealias URLsParams = (
        directory: FileManager.SearchPathDirectory,
        domainMask: FileManager.SearchPathDomainMask
    )
    typealias FileExistsParams = String
    typealias ContentsParams = String
    typealias RemoveItemCalledParam = URL

    private(set) var urlsCalledCount = 0
    private(set) var urlsCalledParams: URLsParams?
    private(set) var fileExistsCalledCount = 0
    private(set) var fileExistsCalledParams: FileExistsParams?
    private(set) var contentsCalledCount = 0
    private(set) var contentsCalledParams: ContentsParams?
    private(set) var createDirectoryCalledCount = 0
    private(set) var createDirectoryCalledParam: CreateDirectoryParams?
    private(set) var createFileCalledCount = 0
    private(set) var createFileCalledParam: CreateFileCalledParam?
    private(set) var removeItemCalledCount = 0
    private(set) var removeItemCalledParam: RemoveItemCalledParam?

    var urls: [URL]
    var fileExistsResult: Bool
    var contentResult: Data?
    var createFileResult: Bool

    init(
        urls: [URL] = [.init(string: "file:///Users/tester/Caches")!],
        fileExistsResult: Bool = false,
        contentResult: Data? = "TestData".data(using: .utf8),
        createFileResult: Bool = true
    ) {
        self.urls = urls
        self.fileExistsResult = fileExistsResult
        self.contentResult = contentResult
        self.createFileResult = createFileResult
    }

    func urls(
        for directory: FileManager.SearchPathDirectory,
        in domainMask: FileManager.SearchPathDomainMask
    ) -> [URL] {
        urlsCalledParams = (directory, domainMask)
        urlsCalledCount += 1
        return urls
    }

    func fileExists(atPath path: String) -> Bool {
        fileExistsCalledParams = path
        fileExistsCalledCount += 1
        return fileExistsResult
    }

    func contents(atPath: String) -> Data? {
        contentsCalledParams = atPath
        contentsCalledCount += 1
        return contentResult
    }

    func createDirectory(
        at url: URL,
        withIntermediateDirectories createIntermediates: Bool,
        attributes: [FileAttributeKey: Any]?
    ) throws {
        createDirectoryCalledParam = .init(url: url, createIntermediates: createIntermediates, attributes: attributes)
        createDirectoryCalledCount += 1
    }

    func createFile(
        atPath path: String,
        contents data: Data?,
        attributes attr: [FileAttributeKey: Any]?
    ) -> Bool {
        createFileCalledParam = .init(path: path, data: data, attr: attr)
        createFileCalledCount += 1
        return createFileResult
    }

    func removeItem(at url: URL) throws {
        removeItemCalledParam = url
        removeItemCalledCount += 1
    }
}

extension TestFileManager {
    struct CreateDirectoryParams {
        let url: URL
        let createIntermediates: Bool
        let attributes: [FileAttributeKey: Any]?
    }

    struct CreateFileCalledParam {
        let path: String
        let data: Data?
        let attr: [FileAttributeKey: Any]?
    }
}
