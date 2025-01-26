//
//  ChecklistViewController.swift
//  Checklists
//
//  Created by Mohsin Ali Ayub on 25.01.25.
//

import UIKit

class ChecklistViewController: UITableViewController {
    
    // data-model
    private let row0Text = "Walk the dog"
    private let row1Text = "Brush my teeth"
    private let row2Text = "Learn iOS development"
    private let row3Text = "Soccer practice"
    private let row4Text = "Eat ice cream"
    
    private var row0Checked = false
    private var row1Checked = true
    private var row2Checked = true
    private var row3Checked = false
    private var row4Checked = true
    
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
            label.text = row0Text
        } else if indexPath.row == 1 {
            label.text = row1Text
        } else if indexPath.row == 2 {
            label.text = row2Text
        } else if indexPath.row == 3 {
            label.text = row3Text
        } else if indexPath.row == 4 {
            label.text = row4Text
        }
        
        configureCheckmark(for: cell, at: indexPath)
        
        return cell
    }
    
    // MARK: - Table View Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            
            if indexPath.row == 0 {
                row0Checked.toggle()
            } else if indexPath.row == 1 {
                row1Checked.toggle()
            } else if indexPath.row == 2 {
                row2Checked.toggle()
            } else if indexPath.row == 3 {
                row3Checked.toggle()
            } else if indexPath.row == 4 {
                row4Checked.toggle()
            }
            
            configureCheckmark(for: cell, at: indexPath)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Data Model Helpers
    
    private func configureCheckmark(for cell: UITableViewCell, at indexPath: IndexPath) {
        var isChecked = false
        
        if indexPath.row == 0 {
            isChecked = row0Checked
        } else if indexPath.row == 1 {
            isChecked = row1Checked
        } else if indexPath.row == 2 {
            isChecked = row2Checked
        } else if indexPath.row == 3 {
            isChecked = row3Checked
        } else if indexPath.row == 4 {
            isChecked = row4Checked
        }
        
        cell.accessoryType = isChecked ? .checkmark : .none
    }
}

