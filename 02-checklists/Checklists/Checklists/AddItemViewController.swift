//
//  AddItemViewController.swift
//  Checklists
//
//  Created by Mohsin Ali Ayub on 26.01.25.
//

import UIKit

/// Methods for managing the adding, editing and cancelling of a to-do item.
///
/// Use the methods of this protocol to manage the following:
/// - The user cancelled the creation of a new to-do item.
/// - The user created a new to-do item.
/// - The existing to-do item has been edited.
protocol AddItemViewControllerDelegate: AnyObject {
    /// Tells the delegate the ``AddItemViewController`` canceled the adding/editing of a to-do item.
    /// - Parameters:
    ///   - controller: An `AddItemViewController` telling the delegate about the impending cancellation.
    func addItemViewControllerDidCancel(_ controller: AddItemViewController)
    
    /// Tells the delegate the ``AddItemViewController`` finished creating a new to-do item..
    ///
    /// - Parameters:
    ///   - controller: An `AddItemViewController` telling the delegate about the impending addition.
    ///   - item: A new to-do object.
    func addItemViewController(_ controller: AddItemViewController, didFinishAdding item: ChecklistItem)
    
    /// Tells the delegate the ``AddItemViewController`` finished editing the existing to-do item..
    ///  
    /// - Parameters:
    ///   - controller: An `AddItemViewController` telling the delegate about the impending editing of a to-do item.
    ///   - item: The edited to-do item.
    func addItemViewController(_ controller: AddItemViewController, didFinishEditing item: ChecklistItem)
}

class AddItemViewController: UITableViewController {
    
    // MARK: - Outlets
    @IBOutlet private weak var textField: UITextField!
    @IBOutlet private weak var doneBarButton: UIBarButtonItem!
    
    // MARK: - Properties
    weak var delegate: AddItemViewControllerDelegate?
    /// The to-do item to edit. It is `nil` when creating a new to-do item.
    var itemToEdit: ChecklistItem?
    
    // MARK: - View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // If there's an item to edit
        //     - Update the title in navigation bar
        //     - Set the text of textField to item's text
        //     - Enable the done button since to-do item already contains text.
        if let itemToEdit {
            title = "Edit Item"
            textField.text = itemToEdit.text
            doneBarButton.isEnabled = true
        }
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
        // Check if we are editing an existing item.
        // Call appropriate delegate method to notify of the procedure.
        if let item = itemToEdit {
            item.text = textField.text!
            delegate?.addItemViewController(self, didFinishEditing: item)
        } else {
            let item = ChecklistItem(text: textField.text!)
            delegate?.addItemViewController(self, didFinishAdding: item)
        }
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
