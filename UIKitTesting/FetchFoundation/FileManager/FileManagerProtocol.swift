//
//  FileManagerProtocol.swift
//
//
//  Created by Ben Fortier on 10/12/23.
//

import Foundation

import Foundation



/// Protocol for managing file system operations.
///
/// The `FileManagerProtocol` defines a set of methods for common file system operations like
/// creating directories, getting file contents, moving files, etc. It is implemented by
/// `FileManager` to allow mocking the file system in tests.
///
/// The protocol exposes a subset of `FileManager` methods related to reading/writing files and
/// inspecting the file system. It also includes testability abstractions for directly reading
/// and writing file contents as `Data`.
public protocol FileManagerProtocol: Sendable {
    /// Creates a directory at the specified url.
    ///
    /// - Parameters:
    ///   - url: The url to create the directory at.
    ///   - createIntermediates: Whether to create any missing parent directories.
    ///   - attributes: File system attributes to use when creating the directory.
    func createDirectory(
        at url: URL,
        withIntermediateDirectories createIntermediates: Bool,
        attributes: [FileAttributeKey: Any]?
    ) throws

    /// Gets the contents of the directory at the specified path.
    ///
    /// - Parameter path: The path to the directory.
    /// - Returns: An array of file names for the contents of the directory.
    func contentsOfDirectory(atPath path: String) throws -> [String]

    /// Checks if a file exists at the specified path.
    ///
    /// - Parameter path: The path to check.
    /// - Returns: `true` if a file exists at the path, `false` otherwise.
    func fileExists(atPath path: String) -> Bool


    /// Moves an item from one url to another.
    ///
    /// - Parameters:
    ///   - srcURL: The existing source url.
    ///   - dstURL: The new destination url.
    func moveItem(at srcURL: URL, to dstURL: URL) throws

    /// Removes an item at the specified url.
    ///
    /// - Parameter URL: The url of the item to remove.
    func removeItem(at URL: URL) throws

    /// Removes an item at the specified path.
    ///
    /// - Parameter path: The path of the item to remove.
    func removeItem(atPath path: String) throws

    /// Locates and optionally creates the specified common directory in a domain.
    /// - Parameters:
    ///   - directory: The search path directory.
    ///   - domainMask: The file system domain to search.
    ///   - url: The file URL used to determine the location of the returned URL. Only the volume of this parameter is used
    ///   - shouldCreate: Whether to create the directory if it does not already exist.
    /// - Returns:The URL for the requested directory
    func url(
        for directory: FileManager.SearchPathDirectory,
        in domain: FileManager.SearchPathDomainMask,
        appropriateFor url: URL?,
        create shouldCreate: Bool
    ) throws -> URL


    /// Returns an array of URLs for the specified common directory in the requested domains.
    /// - Parameters:
    ///   - directory: The search path directory.
    ///   - domainMask: The file system domain to search.
    /// - Returns:An array of URLs for the specified common directory in the requested domains.
    func urls(
        for directory: FileManager.SearchPathDirectory,
        in domainMask: FileManager.SearchPathDomainMask
    ) -> [URL]

    /// Returns the attributes of the item at the `path` passed in
    /// - Parameter path: The path of the item
    /// - Returns: The attributes of the item
    func attributesOfItem(
        atPath path: String
    ) throws -> [FileAttributeKey: Any]


    /// Returns the attributes of the file system for the `path` passed in
    /// - Parameter path: The path of the file system
    /// - Returns: The attributes of the file system
    func attributesOfFileSystem(
        forPath path: String
    ) throws -> [FileAttributeKey: Any]

    // MARK: Testability Abstractions


    /// Writes data to a file for testing purposes.
    ///
    /// - Parameters:
    ///   - data: The data to write.
    ///   - filePath: The path to write the data to.
    ///   - options: Options for writing the data.
    func write(
        _ data: Data,
        to filePath: URL,
        options: Data.WritingOptions
    ) throws

    /// Gets the contents of a file as Data for testing.
    ///
    /// - Parameters:
    ///   - filePath: The path to the file.
    ///   - options: Options for reading the file data.
    /// - Returns: The `Data` contents of the file.
    func contentsOf(
        filePath: URL,
        options: Data.ReadingOptions
    ) throws -> Data
}

// MARK: Extension

// Safe as FileManager is thread safe according to documentation
extension FileManager: @unchecked Sendable { }

extension FileManager: FileManagerProtocol {
    /// Writes the passed in `data` to `filePath` supplied using the `options` passed in
    public func write(
        _ data: Data,
        to filePath: URL,
        options: Data.WritingOptions
    ) throws {
        try data.write(
            to: filePath,
            options: options
        )
    }


    /// Retrieves the contents of the`filePath` supplied using the `options` passed in
    public func contentsOf(
        filePath: URL,
        options: Data.ReadingOptions
    ) throws -> Data {
        try Data(
            contentsOf: filePath,
            options: options
        )
    }
}

