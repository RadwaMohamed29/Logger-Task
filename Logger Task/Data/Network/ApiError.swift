//
//  ApiError.swift
//  Logger Task
//
//  Created by Radwa on 01/01/2024.
//

import Foundation

enum ApiError: Error {
    case invalidPath
    case responseError
    case unknown
}

extension ApiError: LocalizedError {
    
    var description: String {
        switch self {
        case .invalidPath:
            return NSLocalizedString("Invalid URL", comment: "Invalid URL")
        case .responseError:
            return NSLocalizedString("Unexpected status code", comment: "Invalid response")
        case .unknown:
            return NSLocalizedString("Unknown error", comment: "Unknown error")
            
        }
    }
}
