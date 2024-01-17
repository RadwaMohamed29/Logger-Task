//
//  Logger.swift
//  Logger Task
//
//  Created by Radwa on 28/12/2023.
//

import Foundation
import UIKit

// MARK: - Logger Types
enum LogLevel: String {
    case error
    case info
    case debug
    
    fileprivate var prefix: String{
        switch self {
        case .error:    return "Error [‼️]"
        case .info:     return "Info [ℹ️]"
        case .debug:    return "Debug [💬]"
        }
    }
}

class Logger{
    
    static let shared = Logger()
    var dataProvider: DataProvider
    
    init(dataProvider: DataProvider = DataProvider()) {
        self.dataProvider = dataProvider
    }
    
    // MARK: - Info
    func info(_ message: String, filename: String = #file, line: Int = #line, funcName: String = #function)  {
        let context = LoggerContext(message: message, className: "\(self)", file: filename, line: line, funcName: funcName)
        handleLog(level: .info,  context: context)
    }
    
    // MARK: - Debug
    func debug(_ message: String, filename: String = #file, line: Int = #line, funcName: String = #function) {
        let context = LoggerContext(message: message, className: "\(self)", file: filename, line: line, funcName: funcName)
        handleLog(level: .debug,  context: context)
    }
    
    // MARK: - Error
    func error(_ message: String, filename: String = #file, line: Int = #line, funcName: String = #function) {
        let context = LoggerContext(message: message, className: "\(self)", file: filename, line: line, funcName: funcName)
        handleLog(level: .error,  context: context)
    }
    
    /// A Custom Logger Handle Print  logging data in debug mode only
    private func handleLog(level: LogLevel, context: LoggerContext){
        var logComponents = "\(level.prefix) "
        guard let url = URL(string: context.file) else{return}
        
        let context = LoggerContext(message: context.message, className: "\(self)", file: url.lastPathComponent, line: context.line, funcName: context.funcName)
        logComponents += context.fullString
        
        dataProvider.create(log: logComponents)
#if DEBUG
        Swift.print(logComponents)
#endif
    }
    

}

extension Logger{
    func deleteLog(){
        dataProvider.delete()
    }
    
    func saveLog(log: String){
        dataProvider.create(log: log)
    }
    
    func filePath() -> URL?{
        guard let filePath = dataProvider.filePath() else{return nil}
        return  filePath
    }
}



//MARK: - Public Method
public func logInfo(_ message: String){
    Logger.shared.info(message)
}
public func logDebuge(_ message: String){
    Logger.shared.debug(message)
}
public func logError(_ message: String){
    Logger.shared.error(message)
}
