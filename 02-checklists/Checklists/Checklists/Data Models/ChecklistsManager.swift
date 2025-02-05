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
class ChecklistsManager {
    /// A collection of to-do lists. Each to-do list has multiple to-do items in it.
    private(set) var checklists: [Checklist]
    
    init() {
        checklists = []
        // Load checklists.
        loadChecklists()
        // Register default values.
        registerDefaults()
        // Handle the app's fresh install run experience.
        handleFirstRunExperience()
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
    
    /// Handle the unique experience of a fresh app install.
    ///
    /// It creates a new Checklist and makes the index of the Checklist as selected,
    /// so user is navigated to that Checklist and start creating new to-do items right away.
    ///
    /// It resets the first run so user should not navigate to default checklist everytime the app is run.
    private func handleFirstRunExperience() {
        let userDefaults = UserDefaults.standard
        let firstRun = userDefaults.bool(forKey: UserDefaultsKeys.firstRun)
        
        if firstRun {
            let checklist = Checklist(name: "List")
            checklists.append(checklist)
            
            indexOfSelectedChecklist = 0
            userDefaults.set(false, forKey: UserDefaultsKeys.firstRun)
        }
    }
    
    /// Sorts the `checklists` alphabetically.
    func sortChecklists() {
        checklists.sort()
    }
    
    // MARK: - UserDefaults Helpers
    
    /// Registers a default set of values for `selected checklist` and app's `first run` after a fresh install.
    private func registerDefaults() {
        let dictionary: [String: Any] = [
            UserDefaultsKeys.selectedChecklistIndex: -1,
            UserDefaultsKeys.firstRun: true
        ]
        UserDefaults.standard.register(defaults: dictionary)
    }
    
    var indexOfSelectedChecklist: Int {
        get { UserDefaults.standard.integer(forKey: UserDefaultsKeys.selectedChecklistIndex) }
        set { UserDefaults.standard.set(newValue, forKey: UserDefaultsKeys.selectedChecklistIndex)}
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
                sortChecklists() // Sort the checklists.
            } catch {
                print("Error decoding item array: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - UserDefaults Constants
    
    private enum UserDefaultsKeys {
        /// A key for last selected checklist's index.
        static let selectedChecklistIndex = "ChecklistIndex"
        /// A key to describe a first time app's run after a fresh install.
        static let firstRun = "FirstRun"
    }
}
