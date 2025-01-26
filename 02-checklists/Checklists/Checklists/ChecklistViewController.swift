//
//  ChecklistViewController.swift
//  Checklists
//
//  Created by Mohsin Ali Ayub on 25.01.25.
//

import UIKit

class ChecklistViewController: UITableViewController {
    
    // data-model
    private let row0Item = ChecklistItem(text: "Walk the dog")
    private let row1Item = ChecklistItem(text: "Brush my teeth", checked: true)
    private let row2Item = ChecklistItem(text: "Learn iOS development", checked: true)
    private let row3Item = ChecklistItem(text: "Soccer practice")
    private let row4Item = ChecklistItem(text: "Eat ice cream", checked: true)
    
    // Properties
    private let cellIdentifier = "ChecklistItem"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Table View Data Source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        
        let label = cell.viewWithTag(1000) as! UILabel
        
        if indexPath.row == 0 {
            label.text = row0Item.text
        } else if indexPath.row == 1 {
            label.text = row1Item.text
        } else if indexPath.row == 2 {
            label.text = row2Item.text
        } else if indexPath.row == 3 {
            label.text = row3Item.text
        } else if indexPath.row == 4 {
            label.text = row4Item.text
        }
        
        configureCheckmark(for: cell, at: indexPath)
        
        return cell
    }
    
    // MARK: - Table View Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            
            if indexPath.row == 0 {
                row0Item.checked.toggle()
            } else if indexPath.row == 1 {
                row1Item.checked.toggle()
            } else if indexPath.row == 2 {
                row2Item.checked.toggle()
            } else if indexPath.row == 3 {
                row3Item.checked.toggle()
            } else if indexPath.row == 4 {
                row4Item.checked.toggle()
            }
            
            configureCheckmark(for: cell, at: indexPath)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Data Model Helpers
    
    private func configureCheckmark(for cell: UITableViewCell, at indexPath: IndexPath) {
        var isChecked = false
        
        if indexPath.row == 0 {
            isChecked = row0Item.checked
        } else if indexPath.row == 1 {
            isChecked = row1Item.checked
        } else if indexPath.row == 2 {
            isChecked = row2Item.checked
        } else if indexPath.row == 3 {
            isChecked = row3Item.checked
        } else if indexPath.row == 4 {
            isChecked = row4Item.checked
        }
        
        cell.accessoryType = isChecked ? .checkmark : .none
    }
}

