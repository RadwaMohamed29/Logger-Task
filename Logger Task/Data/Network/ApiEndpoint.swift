//
//  APIEndpoint.swift
//  Logger Task
//
//  Created by Radwa on 31/12/2023.
//

import Foundation

enum ApiEndpoint {
    case getLoggerStatus
    case saveLoggerData
    
    enum Method: String {
        case GET
        case POST
        case PUT
        case DELETE
    }
    

}

extension ApiEndpoint {
    
    /// The path for every endpoint
    var path: String {
        switch self {
        case .getLoggerStatus:
            return "/api/logger_status"
        case .saveLoggerData:
            return "/api/logger_data"
        }
    }
    
    /// The method for the endpoint
    var method: ApiEndpoint.Method {
        switch self {
        case .saveLoggerData:
            return .POST
        default:
            return .GET
        }
    }
}
