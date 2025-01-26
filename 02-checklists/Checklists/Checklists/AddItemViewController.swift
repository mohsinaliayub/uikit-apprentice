//
//  AddItemViewController.swift
//  Checklists
//
//  Created by Mohsin Ali Ayub on 26.01.25.
//

import UIKit

/// Methods for managing the addition, edition and cancellation of a to-do item.
protocol AddItemViewControllerDelegate: AnyObject {
    /// Tells the delegate the ``AddItemViewController`` canceled the addition of a new to-do item.
    /// - Parameters:
    ///   - controller: An `AddItemViewController` telling the delegate about the impending cancellation.
    func addItemViewControllerDidCancel(_ controller: AddItemViewController)
    
    /// Tells the delegate the ``AddItemViewController`` finished creating a new to-do item..
    ///
    /// - Parameters:
    ///   - controller: An `AddItemViewController` telling the delegate about the impending addition.
    ///   - item: A new to-do object.
    func addItemViewController(_ controller: AddItemViewController, didFinishAdding item: ChecklistItem)
}

class AddItemViewController: UITableViewController {
    
    // MARK: - Outlets
    @IBOutlet private weak var textField: UITextField!
    @IBOutlet private weak var doneBarButton: UIBarButtonItem!
    
    // MARK: - Properties
    weak var delegate: AddItemViewControllerDelegate?
    
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
        delegate?.addItemViewControllerDidCancel(self)
    }
    
    @IBAction private func done() {
        let item = ChecklistItem(text: textField.text!)
        
        delegate?.addItemViewController(self, didFinishAdding: item)
    }
    
    
    // MARK: - Table View Delegate
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
}

// MARK: - Text Field Delegate

extension AddItemViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Read current text.
        let oldText = textField.text!
        // Create a Range in our oldText.
        let stringRange = Range(range, in: oldText)!
        // Replace the range with new string.
        let newText = oldText.replacingCharacters(in: stringRange, with: string)
        
        // Disable the button if newText is empty.
        doneBarButton.isEnabled = !newText.isEmpty
        
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        // Disable the done button.
        doneBarButton.isEnabled = false
        return true
    }
    
}
