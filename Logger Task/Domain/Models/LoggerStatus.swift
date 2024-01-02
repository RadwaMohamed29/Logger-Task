//
//  LoggerStatus.swift
//  Logger Task
//
//  Created by Radwa on 31/12/2023.
//

import Foundation

// MARK: - LoggerStatus
struct LoggerStatus: Codable {
    let status: Bool?
    
    enum CodingKeys: String, CodingKey {
        case status 
        
    }
}
