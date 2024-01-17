//
//  LogModel.swift
//  Logger Task
//
//  Created by Radwa on 28/12/2023.
//

import Foundation
import UIKit

struct LoggerContext: Codable{
 //   let isMainThread: Bool
  //  let date: String
    let message: String
  //  let appState: String
    let className: String
    let file: String
    let line: Int
    let funcName: String
    
    var fullString: String{
      
        return  "[MainThread:\(Thread.isMainThread)] " + "[\( Date().toString())] " + "[AppState: \(UIApplication.willEnterForegroundNotification)] " + "[ClassName:\(className)] " + "[FileName: \(file)] " + "[Line: \(line)] " + "[FuncName:\(funcName)]" + " ->\(message)"
    }
    
}

// NotificationCenter.default.addObserver(self, selector: #selector(appWillEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
/**
 @objc func appWillEnterForeground() {
     print("App will enter foreground")
     // Add your code here for actions to be taken when the app enters foreground
 }

 */
