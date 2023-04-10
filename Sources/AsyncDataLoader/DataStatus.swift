//
//  DataStatus.swift
//  AsyncDataLoader
//
//  Created by Alvin He on 23/2/2023.
//

import Foundation

public enum DataStatus: Equatable, Sendable {
    case inProgress(Double)
    case finished(Data)
}
