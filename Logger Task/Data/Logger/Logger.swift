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
     func info(_ message: String, filename: String = #file, line: Int = #line, column: Int = #column, funcName: String = #function)  {
         let context = LoggerContext(isMainThread: Thread.isMainThread, date: Date().toString(), message: message, appState: Logger.checkApplicationState(), className: "\(self)", file: Logger.sourceFileName(filePath: filename), line: line, funcName: funcName)
        
        handleLog(level: .info,  context: context)
    }
    
    // MARK: - Debug
     func debug(_ message: String, filename: String = #file, line: Int = #line, column: Int = #column, funcName: String = #function) {
         let context = LoggerContext(isMainThread: Thread.isMainThread, date: Date().toString(), message: message, appState: Logger.checkApplicationState(), className: "\(self)", file: filename, line: line, funcName: funcName)
        
        handleLog(level: .debug,  context: context)
    }
    
    // MARK: - Error
     func error(_ message: String, filename: String = #file, line: Int = #line, column: Int = #column, funcName: String = #function) {
         let context = LoggerContext(isMainThread: Thread.isMainThread, date: Date().toString(), message: message, appState: Logger.checkApplicationState(), className: "\(self)", file: Logger.sourceFileName(filePath: filename), line: line, funcName: funcName)
       handleLog(level: .error,  context: context)
    }

    /// A Custom Logger Handle Print  logging data in debug mode only
    private func handleLog(level: LogLevel, context: LoggerContext){
        var logComponents = "\(level.prefix) "
        NotificationCenter.default.addObserver(self, selector: #selector(appWillEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        let fullString = "[MainThread:\(context.isMainThread)] " + "[\(context.date)] " + "[AppState: \(context.appState)] " + "[ClassName:\(self)] " + "[FileName: \(context.file)] " + "[Line: \(context.line)] " + "[FuncName:\(context.funcName)]" + " ->\(context.message)"

        logComponents.append(contentsOf: fullString )
        
        dataProvider.create(log: logComponents)
#if DEBUG
        Swift.print(logComponents)
#endif
    }
    
    @objc func appWillEnterForeground() {
          print("App will enter foreground")
          // Add your code here for actions to be taken when the app enters foreground
      }
    private class func checkApplicationState() -> String{
        let appState = UIApplication.shared.applicationState
        
        switch appState {
        case .active:
            return "Active"
        case .inactive:
            return "Inactive"
        case .background:
            return "background"
        default:
            fatalError("Unknown application state encountered.")
        }
    }
    
    /// Extract the file name from the file path
    private class func sourceFileName(filePath: String) -> String {
        let components = filePath.components(separatedBy: "/")
        return components.isEmpty ? "" : components.last!
    }
    
    


}
extension Logger{
    func deleteLog(){
        dataProvider.delete()
    }
    
    func saveLog(log: String){
        dataProvider.create(log: log)
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
