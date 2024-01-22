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
    private var dataProvider: DataProvider
    private var isInBackground:Bool = false
    private var requiredLog: LogLevel = .debug
    
    private init(dataProvider: DataProvider = DataProvider()) {
        self.dataProvider = dataProvider
        
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(didEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
    }
    
    @objc func willEnterForeground() {
        isInBackground = false
    }
    
    @objc func didEnterBackground() {
        isInBackground = true
    }
    
    func setRequired(_ log:LogLevel){
        requiredLog = log
    }
    
    /// A Custom Logger Handle Print  logging data in debug mode only
    func handleLog(level: LogLevel, context: LoggerContext){
        var logComponents = "\(level.prefix) "
        logComponents += context.fullString
        
        /// Logs Data according on the required levelLog
        switch requiredLog {
        case .info:
            if level == .error || level == .info{
                shouldLog(log: logComponents)
            }
        case .debug:
            shouldLog(log: logComponents)
            
        case .error:
            if level == .error{
                shouldLog(log: logComponents)
            }
        }
    }
    
    private func shouldLog(log: String) {
        dataProvider.create(log: log)
#if DEBUG
        Swift.print(log)
#endif
        
    }
    
}

/// deal with data provider methods from logger class
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



//MARK: - Public Logger Method
public func logInfo(_ message: String, filename: String = #file, line: Int = #line, funcName: String = #function){
    let context = LoggerContext(message: message, file: filename, line: line, funcName: funcName)
    Logger.shared.handleLog(level: .info,  context: context)
}
public func logDebuge(_ message: String, filename: String = #file, line: Int = #line, funcName: String = #function){
    let context = LoggerContext(message: message, file: filename, line: line, funcName: funcName)
    Logger.shared.handleLog(level: .debug,  context: context)
}
public func logError(_ message: String, filename: String = #file, line: Int = #line, funcName: String = #function){
    let context = LoggerContext(message: message, file: filename, line: line, funcName: funcName)
    Logger.shared.handleLog(level: .error,  context: context)
}
