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
    /// A collection of to-do items of a checklist (i.e. to-do list).
    private var items: [ChecklistItem] {
        checklist.items
    }
    /// A to-do list containing multiple to-do items.
    var checklist: Checklist!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = checklist.name
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
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        // Remove the to-do item from items array.
        checklist.removeItem(at: indexPath.row)
        
        // Remove the item from table view to keep it in sync with data.
        tableView.deleteRows(at: [indexPath], with: .automatic)
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
}

// MARK: - Add Item View Controller Delegate

extension ChecklistViewController: ItemDetailViewControllerDelegate {
    
    func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishAdding item: ChecklistItem) {
        navigationController?.popViewController(animated: true)
        addChecklistItem(item)
    }
    
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishEditing item: ChecklistItem) {
        navigationController?.popViewController(animated: true)
        updateChecklistItem(item)
    }
    
    /// Adds a to-do item to the `items` array and updates the table view.
    /// - Parameter item: The new to-do item.
    private func addChecklistItem(_ item: ChecklistItem) {
        // Find the index for the new to-do item.
        let newRowIndex = items.count
        
        // Add to-do item to items array.
        checklist.addItem(item)
        
        // Let the table view know that there are new rows to be added.
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }
    
    /// Updates an existing to-do item in the `items` array and updates the table view.
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
