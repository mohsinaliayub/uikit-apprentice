//
//  ChecklistViewController.swift
//  Checklists
//
//  Created by Mohsin Ali Ayub on 25.01.25.
//

import UIKit

class ChecklistViewController: UITableViewController {
    
    // Properties
    private let cellIdentifier = "ChecklistItem"
    /// A collection of to-do items.
    private var items = [ChecklistItem]()
    /// A to-do list containing multiple to-do items.
    var checklist: Checklist!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = checklist.name
        // Load checklist items (i.e. to-do items) at app start.
        loadChecklistItems()
    }
    
    // MARK: - Table View Data Source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        
        let item = items[indexPath.row]
        configureText(for: cell, with: item)
        configureCheckmark(for: cell, with: item)
        
        return cell
    }
    
    // MARK: - Table View Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            let item = items[indexPath.row]
            item.checked.toggle()
            
            configureCheckmark(for: cell, with: item)
            
            // Updated an existing item -> Save items array.
            saveChecklistItems()
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        // Remove the to-do item from items array.
        items.remove(at: indexPath.row)
        
        // Remove the item from table view to keep it in sync with data.
        tableView.deleteRows(at: [indexPath], with: .automatic)
        
        // Removed an item from items -> Save items array.
        saveChecklistItems()
    }
    
    // MARK: - Data Model Helpers
    
    /// Displays the description of the `item` in the cell.
    private func configureText(for cell: UITableViewCell, with item: ChecklistItem) {
        let label = cell.viewWithTag(1000) as! UILabel
        label.text = item.text
    }
    
    /// Displays a checkmark for the `item` in the cell if the `item` is marked as completed.
    private func configureCheckmark(for cell: UITableViewCell, with item: ChecklistItem) {
        let label = cell.viewWithTag(1001) as! UILabel
        label.text = item.checked ? "√" : "  "
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddItem" {
            let addItemVC = segue.destination as! ItemDetailViewController
            addItemVC.delegate = self
        } else if segue.identifier == "EditItem" {
            let editItemVC = segue.destination as! ItemDetailViewController
            editItemVC.delegate = self
            
            // Get the indexPath for the cell that triggered this segue.
            if let indexPath = tableView.indexPath(for: sender as! UITableViewCell) {
                editItemVC.itemToEdit = items[indexPath.row]
            }
        }
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
    
    /// Saves Checklist objects into a property list file.
    func saveChecklistItems() {
        // Create a property list encoder.
        let encoder = PropertyListEncoder()
        
        do {
            // Encode checklist objects into data.
            let data = try encoder.encode(items)
            
            // Save encoded data to file.
            try data.write(to: dataFilePath(), options: .atomic)
        } catch {
            print("Error encoding item array: \(error.localizedDescription)")
        }
    }
    
    /// Reads Checklist objects from a property list file, and loads them in ``items`` array.
    func loadChecklistItems() {
        // Get the URL for property list file.
        let filePath = dataFilePath()
        
        // Read data from plist file
        if let data = try? Data(contentsOf: filePath) {
            // Create a decoder to decode binary data.
            let decoder = PropertyListDecoder()
            
            // Decode data and save it in our items array. Handle error if it fails.
            do {
                items = try decoder.decode([ChecklistItem].self, from: data)
            } catch {
                print("Error decoding item array: \(error.localizedDescription)")
            }
        }
    }
}

// MARK: - Add Item View Controller Delegate

extension ChecklistViewController: ItemDetailViewControllerDelegate {
    
    func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishAdding item: ChecklistItem) {
        navigationController?.popViewController(animated: true)
        addChecklistItem(item)
        // Added a new item -> Save items array.
        saveChecklistItems()
    }
    
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishEditing item: ChecklistItem) {
        navigationController?.popViewController(animated: true)
        updateChecklistItem(item)
        // Updated an existing item -> Save items array.
        saveChecklistItems()
    }
    
    /// Adds a to-do item to the `items` array and updates the table view.
    /// - Parameter item: The new to-do item.
    private func addChecklistItem(_ item: ChecklistItem) {
        // Find the index for the new to-do item.
        let newRowIndex = items.count
        
        // Add to-do item to items array.
        items.append(item)
        
        // Let the table view know that there are new rows to be added.
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }
    
    /// Adds a to-do item to the `items` array and updates the table view.
    /// - Parameter item: The edited to-do item.
    private func updateChecklistItem(_ item: ChecklistItem) {
        // Find the index for the item in items array.
        if let index = items.firstIndex(of: item) {
            // Create an index path.
            let indexPath = IndexPath(row: index, section: 0)
            // Find the cell for edited item, and update the text.
            if let cell = tableView.cellForRow(at: indexPath) {
                configureText(for: cell, with: item)
            }
        }
    }
}
