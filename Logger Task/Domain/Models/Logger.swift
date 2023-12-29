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
    
    // MARK: - Date Formatter
    static var dateFormat = "yyyy-MM-dd hh:mm:ssSSS"
    static var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        formatter.locale = Locale.current
        formatter.timeZone = TimeZone.current
        return formatter
    }
    

    // MARK: - Info
    static func info(_ str: String, filename: String = #file, line: Int = #line, column: Int = #column, funcName: String = #function, isLoggingEnabled: Bool = true) {
        let context = Context(isMainThread: Thread.isMainThread, date: Date().toString(), message: str, appState: "\(UIApplication.shared.applicationState.rawValue)", className: "\(self)", file: filename, line: line, funcName: funcName, logLevel: "")
        Logger.handleLog(level: .info,  isLoggingEnabled: isLoggingEnabled, context: context)
        }
    
    // MARK: - Debug
    static func debug(_ str: String, filename: String = #file, line: Int = #line, column: Int = #column, funcName: String = #function, isLoggingEnabled: Bool = true) {
        let context = Context(isMainThread: Thread.isMainThread, date: Date().toString(), message: str, appState: "\(UIApplication.shared.applicationState.rawValue)", className: "\(self)", file: filename, line: line, funcName: funcName, logLevel: "")
        Logger.handleLog(level: .debug,  isLoggingEnabled: isLoggingEnabled, context: context)
        }
    
    // MARK: - Error
    static func error(_ str: String, filename: String = #file, line: Int = #line, column: Int = #column, funcName: String = #function, isLoggingEnabled: Bool = true) {
        let context = Context(isMainThread: Thread.isMainThread, date: Date().toString(), message: str, appState: "\(UIApplication.shared.applicationState.rawValue)", className: "\(self)", file: filename, line: line, funcName: funcName, logLevel: "")
        Logger.handleLog(level: .error,  isLoggingEnabled: isLoggingEnabled, context: context)
        }
    
    /// A Custom Logger Handle Print  logging data in debug mode only
    fileprivate static func handleLog(level: LogLevel, isLoggingEnabled: Bool, context: Context){
        let logComponents = ["\(level.prefix) "]
        var fullString = logComponents.joined(separator: " ")
        
        if isLoggingEnabled{
            fullString += "[MainThread:\(context.isMainThread)] " + "[\(context.date)] " + "[AppState: \(context.appState)] " + "[ClassName:\(self)] " + "[FileName: \(context.file)] " + "[Line: \(context.line)] " + "[FuncName:\(context.funcName)]" + " ->\(context.message)"
        }
        #if DEBUG
        Swift.print(fullString)
        #endif
    }
    
    private class func sourceFileName(filePath: String) -> String {
        let components = filePath.components(separatedBy: "/")
        return components.isEmpty ? "" : components.last!
    }
}

// The Date to String extension
extension Date {
    func toString() -> String {
        return Logger.dateFormatter.string(from: self as Date)
    }
}
