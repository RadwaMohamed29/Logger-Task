//
//  ContextCreator.swift
//  Logger Task
//
//  Created by Radwa on 03/01/2024.
//

import Foundation
import UIKit

class Helper{
    // MARK: - Date Formatter
    static var dateFormat = "yyyy-MM-dd hh:mm:ssSSS"
    static var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        formatter.locale = Locale.current
        formatter.timeZone = TimeZone.current
        return formatter
    }
}

// The Date to String extension
extension Date {
    func toString() -> String {
        return Helper.dateFormatter.string(from: self as Date)
    }
}
