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
            // Open the file in append mode
            let fileHandle = try FileHandle(forWritingTo: URL(fileURLWithPath: filePath.path))
            
            // Move to the end of the file
            fileHandle.seekToEndOfFile()
            
            // Convert the string to data and write it to the file
            let newData = log + "\n \n"
            if let data = newData.data(using: .utf8) {
                fileHandle.write(data)
            }
            
            // Close the file handle
            fileHandle.closeFile()
        } catch {
            // Handle the error
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
