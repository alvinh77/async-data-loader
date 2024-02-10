//
//  ServerSession.swift
//  AsyncDataLoader
//
//  Created by Alvin He on 23/2/2023.
//

import Foundation

/// A protocol representing a file manager for performing file-related operations.
public protocol FileManagerProtocol: Sendable {
    /// Returns an array of URLs for the specified directory in the specified domain.
    ///
    /// - Parameters:
    ///   - directory: The search path directory.
    ///   - domainMask: The domain to search within.
    /// - Returns: An array of URLs representing the contents of the specified directory.
    func urls(for directory: FileManager.SearchPathDirectory, in domainMask: FileManager.SearchPathDomainMask) -> [URL]

    /// Checks whether a file exists at the specified path.
    ///
    /// - Parameter path: The path to the file.
    /// - Returns: `true` if a file exists at the specified path, otherwise `false`.
    func fileExists(atPath path: String) -> Bool

    /// Returns the contents of the file at the specified path.
    ///
    /// - Parameter path: The path to the file.
    /// - Returns: The data representing the contents of the file, or `nil` if the file does not exist or cannot be read.
    func contents(atPath: String) -> Data?

    /// Creates a directory with the specified attributes.
    ///
    /// - Parameters:
    ///   - url: The URL at which to create the directory.
    ///   - createIntermediates: If `true`, creates intermediate directories as needed.
    ///   - attributes: The attributes for the directory.
    /// - Throws: An error if the operation fails.
    func createDirectory(at url: URL, withIntermediateDirectories createIntermediates: Bool, attributes: [FileAttributeKey: Any]?) throws

    /// Creates a file with the specified contents and attributes at the specified path.
    ///
    /// - Parameters:
    ///   - path: The path at which to create the file.
    ///   - data: The data to write to the file.
    ///   - attr: The attributes for the file.
    /// - Returns: `true` if the operation succeeds, otherwise `false`.
    func createFile(atPath path: String, contents data: Data?, attributes attr: [FileAttributeKey: Any]?) -> Bool

    /// Removes the item at the specified URL.
    ///
    /// - Parameter url: The URL of the item to remove.
    /// - Throws: An error if the operation fails.
    func removeItem(at url: URL) throws
}

extension FileManager: FileManagerProtocol, @unchecked Sendable {}
