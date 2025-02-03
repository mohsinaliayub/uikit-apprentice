//
//  ListDetailViewController.swift
//  Checklists
//
//  Created by Mohsin Ali Ayub on 02.02.25.
//

import UIKit

/// Methods for managing the adding, modifying and cancelling of a to-do list.
///
/// Use the methods of this protocol to manage the following:
/// - The user cancelled the creation of a new to-do list.
/// - The user created a new to-do list.
/// - The existing to-do list has been modified.
protocol ListDetailViewControllerDelegate: AnyObject {
    /// Tells the delegate the ``ListDetailViewController`` canceled the adding/editing of a to-do list.
    /// - Parameters:
    ///   - controller: A `ListDetailViewController` telling the delegate about the impending cancellation.
    func listDetailViewControllerDidCancel(_ controller: ListDetailViewController)
    
    /// Tells the delegate the ``ListDetailViewController`` finished creating a new to-do list..
    ///
    /// - Parameters:
    ///   - controller: A `ListDetailViewController` telling the delegate about the impending addition.
    ///   - checklist: A new to-do list.
    func listDetailViewController(_ controller: ListDetailViewController, didFinishAdding checklist: Checklist)
    
    /// Tells the delegate the ``ListDetailViewController`` finished editing the existing to-do item..
    ///
    /// - Parameters:
    ///   - controller: A `ListDetailViewController` telling the delegate about the impending modification of a to-do list.
    ///   - checklist: The edited to-do list.
    func listDetailViewController(_ controller: ListDetailViewController, didFinishEditing checklist: Checklist)
}

class ListDetailViewController: UITableViewController {
    // MARK: - Outlets
    @IBOutlet private weak var textField: UITextField!
    @IBOutlet private weak var doneBarButton: UIBarButtonItem!
    
    // MARK: - Properties
    weak var delegate: ListDetailViewControllerDelegate?
    /// The to-do list to edit. It is `nil` when creating a new to-do list.
    var checklistToEdit: Checklist?
    
    // MARK: - View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // If there's a checklist to edit
        //     - Update the title in navigation bar
        //     - Set the text of textField to checklist's name
        //     - Enable the done button since to-do list already contains text.
        if let checklistToEdit {
            self.title = "Edit Checklist"
            textField.text = checklistToEdit.name
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
        delegate?.listDetailViewControllerDidCancel(self)
    }
    
    @IBAction private func done() {
        // Check if we are editing an existing checklist.
        // Call appropriate delegate method to notify of the procedure.
        if let checklist = checklistToEdit {
            checklist.name = textField.text!
            delegate?.listDetailViewController(self, didFinishEditing: checklist)
        } else {
            let checklist = Checklist(name: textField.text!)
            delegate?.listDetailViewController(self, didFinishAdding: checklist)
        }
    }
    
    
    // MARK: - Table View Delegate
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
}

// MARK: - Text Field Delegate

extension ListDetailViewController: UITextFieldDelegate {
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
