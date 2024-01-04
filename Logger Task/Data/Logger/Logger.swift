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
    
    // MARK: - Info
    static func info(_ str: String, filename: String = #file, line: Int = #line, column: Int = #column, funcName: String = #function)  {
        let context = LoggerContext(isMainThread: Thread.isMainThread, date: Date().toString(), message: str, appState: "\(UIApplication.shared.applicationState.rawValue)", className: "\(self)", file: filename, line: line, funcName: funcName)
        Logger.handleLog(level: .info,  context: context)
        }
    
    // MARK: - Debug
    static func debug(_ str: String, filename: String = #file, line: Int = #line, column: Int = #column, funcName: String = #function) {
        let context = LoggerContext(isMainThread: Thread.isMainThread, date: Date().toString(), message: str, appState: "\(UIApplication.shared.applicationState.rawValue)", className: "\(self)", file: filename, line: line, funcName: funcName)
        Logger.handleLog(level: .debug,  context: context)
        }
    
    // MARK: - Error
    static func error(_ str: String, filename: String = #file, line: Int = #line, column: Int = #column, funcName: String = #function) {
        let context = LoggerContext(isMainThread: Thread.isMainThread, date: Date().toString(), message: str, appState: "\(UIApplication.shared.applicationState.rawValue)", className: "\(self)", file: filename, line: line, funcName: funcName)
        Logger.handleLog(level: .error,  context: context)
        }
    
    /// A Custom Logger Handle Print  logging data in debug mode only
    fileprivate static func handleLog(level: LogLevel, context: LoggerContext){
        let logComponents = ["\(level.prefix) "]
        var fullString = logComponents.joined(separator: " ")
        DataProvider.shared.create(note: context)
        
        fullString += "[MainThread:\(context.isMainThread)] " + "[\(context.date)] " + "[AppState: \(context.appState)] " + "[ClassName:\(self)] " + "[FileName: \(context.file)] " + "[Line: \(context.line)] " + "[FuncName:\(context.funcName)]" + " ->\(context.message)"
        #if DEBUG
        Swift.print(fullString)
        #endif
    }
    
    
    static func setRequiredLevel(level: LogLevel) {
        
    }

}


