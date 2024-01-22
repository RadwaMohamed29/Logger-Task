//
//  LogModel.swift
//  Logger Task
//
//  Created by Radwa on 28/12/2023.
//

import Foundation
import UIKit

struct LoggerContext{
    let message: String
    let file: String
    let line: Int
    let funcName: String
    var appState: Bool = false
    var fullString: String{
        
        return  "[MainThread:\(Thread.isMainThread)] " + "[\(Date().toString())] " + "[InBackground: \(appState)] " +  "[FileName: \(getLastPath(urlString: file))] " + "[Line: \(line)] " + "[FuncName:\(funcName)]" + " ->\(message)"
    }
    
    
    
    
    func getLastPath(urlString: String) -> String {
        if let url = URL(string: urlString) {
            return url.lastPathComponent
        } else {
            return "Invalid"
        }
    }
    
}
