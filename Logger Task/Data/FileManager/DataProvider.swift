//
//  DataProvider.swift
//  Logger Task
//
//  Created by Radwa on 02/01/2024.
//

import Foundation

class DataProvider {
    
    // MARK: - Methods
    
    func create(log: String) {
        guard let filePath = filePath()else{return}
        do {
//            let message = "Logger Data \n \n"
//            try message.write(to: filePath, atomically: true, encoding: .utf8)
            
            let fileHandle = try FileHandle(forWritingTo: filePath)
            // Move to the end of the file
            fileHandle.seekToEndOfFile()
            let newData = log + "\n \n"
            if let data = newData.data(using: .utf8) {
                fileHandle.write(data)
            }
            fileHandle.closeFile()
            
        } catch {
            logError("Faild to save loges!")
        }
        
        NSLog("path: \(filePath)")
    }
    
    
    func filePath() -> URL?{
        guard let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else{ return nil}
        let filePath = documentsPath.appendingPathComponent("Loges").appendingPathExtension("txt")
        
        return filePath
    }
    
    func delete() {
        guard let filePath = filePath()else{return}
        do {
            try FileManager.default.removeItem(at: filePath)
        } catch {
            logError("Error deleting file: \(error)")
        }
    }
    
}
