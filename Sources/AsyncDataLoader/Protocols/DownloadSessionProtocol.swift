//
//  DownloadSessionProtocol.swift
//  AsyncDataLoader
//
//  Created by Alvin He on 12/3/2024.
//

public protocol DownloadSessionProtocol {
    var downloadStream: AsyncThrowingStream<DataStatus, Error> { get }
}
