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
}

