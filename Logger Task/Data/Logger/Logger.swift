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
    private var appState: String = "False"
    init(dataProvider: DataProvider = DataProvider()) {
        self.dataProvider = dataProvider
    }
    
    /// A Custom Logger Handle Print  logging data in debug mode only
    func handleLog(level: LogLevel, context: LoggerContext){
        var logComponents = "\(level.prefix) "
        
        //        NotificationCenter.default.addObserver(self, selector: #selector(appWillEnterForeground), name: UIApplication.didFinishLaunchingNotification, object: nil)
        
        guard let url = URL(string: context.file) else{return}
        var context = LoggerContext(message: context.message, file: url.lastPathComponent, line: context.line, funcName: context.funcName)
        context.appState = appState
        logComponents += context.fullString
        
        dataProvider.create(log: logComponents)
#if DEBUG
        Swift.print(logComponents)
#endif
    }
    
    //    @objc func appWillEnterForeground() {
    //       appState = "True"
    //    }
    
    func setRequired(_ log:LogLevel ){
       
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
