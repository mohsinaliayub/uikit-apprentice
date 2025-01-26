//
//  AddItemViewController.swift
//  Checklists
//
//  Created by Mohsin Ali Ayub on 26.01.25.
//

import UIKit

class AddItemViewController: UITableViewController {
    
    // MARK: - Outlets
    @IBOutlet private weak var textField: UITextField!
    
    
    // MARK: - View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Open a keyboard before the view appears.
        textField.becomeFirstResponder()
    }
    
    // MARK: - Actions
    
    @IBAction private func cancel() {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction private func done() {
        print(textField.text!)
        navigationController?.popViewController(animated: true)
    }
    
    
    // MARK: - Table View Delegate
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
}
