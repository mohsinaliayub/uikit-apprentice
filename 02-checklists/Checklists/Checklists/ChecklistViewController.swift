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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Create test data.
        items.append(ChecklistItem(text: "Walk the dog"))
        items.append(ChecklistItem(text: "Brush my teeth", checked: true))
        items.append(ChecklistItem(text: "Learn iOS development", checked: true))
        items.append(ChecklistItem(text: "Soccer practice"))
        items.append(ChecklistItem(text: "Eat ice cream", checked: true))
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
        items.remove(at: indexPath.row)
        
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
        cell.accessoryType = item.checked ? .checkmark : .none
    }
    
    // MARK: - Actions
    
    @IBAction func addItem(_ sender: UIBarButtonItem) {
        // Find the index for the new to-do item.
        let newRowIndex = items.count
        
        // Create a new to-do item and append it to the ``items`` array.
        let item = ChecklistItem(text: "I am a new row")
        items.append(item)
        
        // Let the table view know that there are new rows to be added.
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddItem" {
            let addItemVC = segue.destination as! AddItemViewController
            addItemVC.delegate = self
        }
    }
}

// MARK: - Add Item View Controller Delegate

extension ChecklistViewController: AddItemViewControllerDelegate {
    
    func addItemViewControllerDidCancel(_ controller: AddItemViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    func addItemViewController(_ controller: AddItemViewController, didFinishAdding item: ChecklistItem) {
        navigationController?.popViewController(animated: true)
    }
}
