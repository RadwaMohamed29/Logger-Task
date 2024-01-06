//
//  LogModel.swift
//  Logger Task
//
//  Created by Radwa on 28/12/2023.
//

import Foundation

struct LoggerContext: Codable{
    let isMainThread: Bool
    let date: String
    let message: String
    let appState: String
    let className: String
    let file: String
    let line: Int
    let funcName: String
}

struct BaseModel: Codable{
    let success: Bool?
    
}
