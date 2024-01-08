//
//  DataProvider.swift
//  Logger Task
//
//  Created by Radwa on 02/01/2024.
//

import Foundation

class DataProvider: ObservableObject {
    
    // MARK: - Propeties
    static let shared = DataProvider()
    private let dataSourceURL: URL
    @Published var allLoges = [LoggerContext]()
    
    // MARK: - Life Cycle
    init() {
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let filePath = documentsPath.appendingPathComponent("Loges").appendingPathExtension("txt")
        dataSourceURL = filePath
       
    }
    
    // MARK: - Methods
    
    private func saveLogs() {
        
        do {
            let encoder = PropertyListEncoder()
            let data = try encoder.encode(allLoges)
            try data.write(to: dataSourceURL)
        } catch {
            Logger.error("Faild to save loges!")
        }
    }
    
    func create(log: LoggerContext) {
        allLoges.insert(log, at: 0)
        saveLogs()
        Logger.info("File Path: \(dataSourceURL)")
    }
    
    func filePath() -> URL{
        return dataSourceURL
    }
    
    func delete() {
        do {
            try FileManager.default.removeItem(at: dataSourceURL)
        } catch {
            Logger.error("Error deleting file: \(error)")
        }
    }
    
}
