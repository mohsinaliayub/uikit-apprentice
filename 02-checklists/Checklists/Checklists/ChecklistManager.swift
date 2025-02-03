//
//  ChecklistManager.swift
//  Checklists
//
//  Created by Mohsin Ali Ayub on 03.02.25.
//

import Foundation

/// Manages to-do lists.
///
/// It is responsible for saving and loading of to-do lists.
class ChecklistManager {
    /// A collection of to-do lists. Each to-do list has multiple to-do items in it.
    private(set) var checklists: [Checklist]
    
    init() {
        checklists = []
        // Load checklists.
        loadChecklists()
    }
    
    // MARK: - Checklist Helpers
    
    /// Removes a to-do list at specified index.
    ///
    /// - Parameter index: The position of the to-do list to remove. index must be a valid index of the array.
    func removeChecklist(at index: Int) {
        checklists.remove(at: index)
    }
    
    /// Adds a to-do list.
    ///
    /// - Parameter item: The to-do list to add.
    func add(_ checklist: Checklist) {
        checklists.append(checklist)
    }
    
    // MARK: - Data Persistence
        
    /// Returns a URL for the sandboxed Documents directory in the user domain.
    ///
    /// - Returns: URL for the Documents directory.
    func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    /// Returns a URL for the property list file to save/read Checklist objects.
    ///
    /// - Returns: A URL for the property list file.
    func dataFilePath() -> URL {
        documentsDirectory().appending(path: "Checklists.plist")
    }
    
    /// Saves Checklists into a property list file.
    func saveChecklists() {
        // Create a property list encoder.
        let encoder = PropertyListEncoder()
        
        do {
            // Encode checklist objects into data.
            let data = try encoder.encode(checklists)
            
            // Save encoded data to file.
            try data.write(to: dataFilePath(), options: .atomic)
        } catch {
            print("Error encoding item array: \(error.localizedDescription)")
        }
    }
    
    /// Reads Checklist objects from a property list file, and loads them in ``checklists`` array.
    private func loadChecklists() {
        // Get the URL for property list file.
        let filePath = dataFilePath()
        
        // Read data from plist file
        if let data = try? Data(contentsOf: filePath) {
            // Create a decoder to decode binary data.
            let decoder = PropertyListDecoder()
            
            // Decode data and save it in our items array. Handle error if it fails.
            do {
                checklists = try decoder.decode([Checklist].self, from: data)
            } catch {
                print("Error decoding item array: \(error.localizedDescription)")
            }
        }
    }
}
