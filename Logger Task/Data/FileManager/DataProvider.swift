//
//  DataProvider.swift
//  Logger Task
//
//  Created by Radwa on 02/01/2024.
//

import Foundation

class DataProvider {
    
    // MARK: - Propeties

    private var allLoges = [LoggerContext]()
   

    
    // MARK: - Methods
    
    private func saveLogs() {
        /* //writing
         do {
             try text.write(to: fileURL, atomically: false, encoding: .utf8)
         }
         catch {/* error handling here */}*/
        guard let filePath = filePath()else{return}
        do {
            let encoder = PropertyListEncoder()
            let data = try encoder.encode(allLoges)
            try data.write(to: filePath)
        } catch {
            logError("Faild to save loges!")
        }
    }
    
    func create(log: String) {
        
      //  allLoges.insert(log, at: 0)
        saveLogs()
        guard let filePath = filePath()else{return}
        NSLog("path: \(filePath)")
    }
    
    func filePath() -> URL?{
        guard let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else{ return nil}
            let filePath = documentsPath.appendingPathComponent("Loges").appendingPathExtension("txt")
          //  dataSourceURL = filePath
        
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
