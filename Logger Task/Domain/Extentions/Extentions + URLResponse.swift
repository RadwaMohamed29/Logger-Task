//
//  Extentions + URLResponse.swift
//  Logger Task
//
//  Created by Radwa on 31/12/2023.
//

import Foundation

extension URLResponse {
    func getStatusCode() -> Int? {
        if let httpResponse = self as? HTTPURLResponse {
            return httpResponse.statusCode
        }
        return nil
    }
}
