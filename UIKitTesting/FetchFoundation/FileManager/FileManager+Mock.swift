//
//  FileManager+Mock.swift
//
//
//  Created by Ben Fortier on 10/12/23.
//

import Foundation

#if DEBUG

public final class MockFileManager: FileManagerProtocol {
    public static let unimplementedError = NSError(domain: "Unimplemented func", code: -1)

    public typealias CreateDirectoryInvocation = (URL, Bool, [FileAttributeKey: Any]?)
    public var _createDirectoryInvocations: [CreateDirectoryInvocation] = []
    public var _createDirectoryInvocation: CreateDirectoryInvocation?
    public var _createDirectoryResult: (() -> Result<Void, any Error>)?
    public func createDirectory(
        at url: URL,
        withIntermediateDirectories createIntermediates: Bool,
        attributes: [FileAttributeKey: Any]?
    ) throws {
        let invocation = (url, createIntermediates, attributes)
        _createDirectoryInvocations.append(invocation)
        _createDirectoryInvocation = invocation
        guard let _createDirectoryResult else { throw MockFileManager.unimplementedError }
        return try _createDirectoryResult().get()
    }

    public var _contentsOfDirectoryInvocations: [String] = []
    public var _contentsOfDirectoryInvocation: String?
    public var _contentsOfDirectoryResult: (() -> Result<[String], any Error>)?
    public func contentsOfDirectory(
        atPath path: String
    ) throws -> [String] {
        _contentsOfDirectoryInvocations.append(path)
        _contentsOfDirectoryInvocation = path
        guard let _contentsOfDirectoryResult else { throw MockFileManager.unimplementedError }
        return try _contentsOfDirectoryResult().get()
    }

    public var _fileExistsInvocations: [String] = []
    public var _fileExistsInvocation: String?
    public var _fileExistsResult: (() -> Bool)?
    public func fileExists(
        atPath path: String
    ) -> Bool {
        _fileExistsInvocations.append(path)
        _fileExistsInvocation = path
        guard let _fileExistsResult else { fatalError("Unimplemented") }
        return _fileExistsResult()
    }

    public typealias MoveItemInvocation = (URL, URL)
    public var _moveItemInvocations: [MoveItemInvocation] = []
    public var _moveItemInvocation: MoveItemInvocation?
    public var _moveItemResult: (() -> Result<Void, any Error>)?
    public func moveItem(
        at srcURL: URL,
        to dstURL: URL
    ) throws {
        let invocation = (srcURL, dstURL)
        _moveItemInvocations.append(invocation)
        _moveItemInvocation = invocation
        guard let _moveItemResult else { throw MockFileManager.unimplementedError }
        return try _moveItemResult().get()
    }

    public var _removeItemInvocations: [URL] = []
    public var _removeItemInvocation: URL?
    public var _removeItemResult: (() -> Result<Void, any Error>)?
    public func removeItem(
        at URL: URL
    ) throws {
        _removeItemInvocations.append(URL)
        _removeItemInvocation = URL
        guard let _removeItemResult else { throw MockFileManager.unimplementedError }
        return try _removeItemResult().get()
    }

    public var _removeItemAtAPathInvocations: [String] = []
    public var _removeItemAtPathInvocation: String?
    public var _removeItemAtPathResult: (() -> Result<Void, any Error>)?
    public func removeItem(
        atPath path: String
    ) throws {
        _removeItemAtAPathInvocations.append(path)
        _removeItemAtPathInvocation = path
        guard let _removeItemAtPathResult else { throw MockFileManager.unimplementedError }
        return try _removeItemAtPathResult().get()
    }

    public typealias URLInvocation = (FileManager.SearchPathDirectory, FileManager.SearchPathDomainMask, URL?, Bool)
    public var _urlInvocations: [URLInvocation] = []
    public var _urlInvocation: URLInvocation?
    public var _urlResult: (() -> Result<URL, any Error>)?
    public func url(
        for directory: FileManager.SearchPathDirectory,
        in domain: FileManager.SearchPathDomainMask,
        appropriateFor url: URL?,
        create shouldCreate: Bool
    ) throws -> URL {
        let invocation = (directory, domain, url, shouldCreate)
        _urlInvocations.append(invocation)
        _urlInvocation = invocation
        guard let _urlResult else { throw MockFileManager.unimplementedError }
        return try _urlResult().get()
    }

    public typealias URLSInvocation = (FileManager.SearchPathDirectory, FileManager.SearchPathDomainMask)
    public var _urlsInvocations: [URLSInvocation] = []
    public var _urlsInvocation: URLSInvocation?
    public var _urlsResult: (() -> [URL])?
    public func urls(
        for directory: FileManager.SearchPathDirectory,
        in domainMask: FileManager.SearchPathDomainMask
    ) -> [URL] {
        let invocation = (directory, domainMask)
        _urlsInvocations.append(invocation)
        _urlsInvocation = invocation
        guard let _urlsResult else { fatalError("Unimplemented") }
        return _urlsResult()
    }

    public var _attributesOfItemInvocations: [String] = []
    public var _attributesOfItemInvocation: String?
    public var _attributesOfItemResult: (() -> Result<[FileAttributeKey : Any], any Error>)?
    public func attributesOfItem(
        atPath path: String
    ) throws -> [FileAttributeKey : Any] {
      _attributesOfItemInvocations.append(path)
      _attributesOfItemInvocation = path
      guard let _attributesOfItemResult else { throw MockFileManager.unimplementedError }
        return try _attributesOfItemResult().get()
    }

    public var _attributesOfFileSystemInvocations: [String] = []
    public var _attributesOfFileSystemInvocation: String?
    public var _attributesOfFileSystemResult: (() -> Result<[FileAttributeKey : Any], any Error>)?
    public func attributesOfFileSystem(
        forPath path: String
    ) throws -> [FileAttributeKey: Any] {
        _attributesOfFileSystemInvocations.append(path)
        _attributesOfFileSystemInvocation = path
        guard let _attributesOfFileSystemResult else { throw MockFileManager.unimplementedError }
        return try _attributesOfFileSystemResult().get()
    }

    public typealias WriteInvocation = (Data, URL, Data.WritingOptions)
    public var _writeInvocations: [WriteInvocation] = []
    public var _writeInvocation: WriteInvocation?
    public var _writeResult: (() -> Result<Void, any Error>)?
    public func write(
        _ data: Data,
        to filePath: URL,
        options: Data.WritingOptions
    ) throws {
        let invocation: WriteInvocation = (data, filePath, options)
        _writeInvocations.append(invocation)
        _writeInvocation = invocation
        guard let _writeResult else { throw MockFileManager.unimplementedError }
        return try _writeResult().get()
    }

    public typealias ContentsOfInvocation = (URL, Data.ReadingOptions)
    public var _contentsOfInvocations: [ContentsOfInvocation] = []
    public var _contentsOfInvocation: ContentsOfInvocation?
    public var _contentsOfResult: (() -> Result<Data, any Error>)?
    public func contentsOf(
        filePath: URL,
        options: Data.ReadingOptions
    ) throws -> Data {
        let invocation: ContentsOfInvocation = (filePath, options)
        _contentsOfInvocations.append(invocation)
        _contentsOfInvocation = invocation
        guard let _contentsOfResult else { throw MockFileManager.unimplementedError }
        return try _contentsOfResult().get()
    }

    public init() {}
}

#endif
