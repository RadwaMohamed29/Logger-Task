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
        let notesPath = documentsPath.appendingPathComponent("Loges").appendingPathExtension("txt")
        dataSourceURL = notesPath
       
    }
    
    // MARK: - Methods
    
    private func saveNotes() {
        
        do {
            let encoder = PropertyListEncoder()
            let data = try encoder.encode(allLoges)
            try data.write(to: dataSourceURL)
        } catch {
            
        }
    }
    
    func create(note: LoggerContext) {
        allLoges.insert(note, at: 0)
        saveNotes()
        Swift.print("path: \(dataSourceURL)")
    }
    
    func filePath() -> URL{
        return dataSourceURL
    }
    
    func delete() {
        do {
            try FileManager.default.removeItem(at: dataSourceURL)
            print("Successfully deleted file!")
        } catch {
            print("Error deleting file: \(error)")
        }
    }
    
}
