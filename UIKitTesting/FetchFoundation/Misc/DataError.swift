//
//  DataError.swift
//  
//
//  Created by Richard Witherspoon on 11/4/23.
//

import Foundation


public enum DataError: LocalizedError {
    case noData

    public var errorDescription: String? {
        switch self {
        case .noData:
            return "No data could be obtained."
        }
    }
}
