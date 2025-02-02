//
//  AllListsViewController.swift
//  Checklists
//
//  Created by Mohsin Ali Ayub on 02.02.25.
//

import UIKit

class AllListsViewController: UIViewController {
    
    // MARK: Properties
    
    /// Reuse identifier for table view cell.
    private let cellIdentifier = "ChecklistCell"
    /// Identifier for a push segue to display details of a single To-do list.
    private let showChecklistSegueIdentifier = "ShowChecklist"
    /// Identifier for a push segue to add a new To-do list.
    private let addChecklistSegueIdentifier = "AddChecklist"
    /// Identifier for a push segue to edit an existing To-do list.
    private let editChecklistSegueIdentifier = "EditChecklist"
    /// A collection of to-do lists. Each to-do list has multiple to-do items in it.
    private var lists = [Checklist]()
    
    // MARK: Outlets
    
    /// The table view to display and manage a list of To-do lists.
    @IBOutlet private weak var tableView: UITableView!
    
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Register a default cell.
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        
        createDummyData()
    }
    
    private func createDummyData() {
        lists.append(Checklist(name: "Birthdays"))
        lists.append(Checklist(name: "Groceries"))
        lists.append(Checklist(name: "Cool Apps"))
        lists.append(Checklist(name: "To Do"))
    }
    
    // MARK: - Data Display Helpers
    
    /// Displays the name of the `checklist` in the cell.
    ///
    /// - Parameters:
    ///   - cell: The UITableViewCell to display data in.
    ///   - checklist: The to-do list to display.
    private func configureText(for cell: UITableViewCell, with checklist: Checklist) {
        var cellConfiguration = UIListContentConfiguration.cell()
        cellConfiguration.text = checklist.name
        
        cell.contentConfiguration = cellConfiguration
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showChecklistSegueIdentifier {
            // Populate necessary properties to work on.
            let checklistVC = segue.destination as! ChecklistViewController
            checklistVC.checklist = sender as? Checklist
        } else if segue.identifier == addChecklistSegueIdentifier {
            let listDetailVC = segue.destination as! ListDetailViewController
            listDetailVC.delegate = self
        } else if segue.identifier == editChecklistSegueIdentifier {
            let listDetailVC = segue.destination as! ListDetailViewController
            listDetailVC.delegate = self
            listDetailVC.checklistToEdit = sender as? Checklist
        }
    }
}

// MARK: - Table View Data Source

extension AllListsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        
        let list = lists[indexPath.row]
        
        configureText(for: cell, with: list)
        cell.accessoryType = .detailDisclosureButton
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        // Remove Checklist.
        lists.remove(at: indexPath.row)
        // Remove the row from table view to keep it in sync with data.
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
}

// MARK: - Table View Delegate

extension AllListsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Navigate to ChecklistViewController. Deselect the row.
        let checklist = lists[indexPath.row]
        
        performSegue(withIdentifier: showChecklistSegueIdentifier, sender: checklist)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        // Go to ListDetailViewController to edit a checklist
        let checklist = lists[indexPath.row]
        performSegue(withIdentifier: editChecklistSegueIdentifier, sender: checklist)
    }
}


// MARK: - List Detail View Controller

extension AllListsViewController: ListDetailViewControllerDelegate {
    func listDetailViewControllerDidCancel(_ controller: ListDetailViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    func listDetailViewController(_ controller: ListDetailViewController, didFinishAdding checklist: Checklist) {
        navigationController?.popViewController(animated: true)
        addChecklist(checklist)
    }
    
    func listDetailViewController(_ controller: ListDetailViewController, didFinishEditing checklist: Checklist) {
        navigationController?.popViewController(animated: true)
        updateChecklist(checklist)
    }
    
    /// Adds a to-do list to the `lists` array and updates the table view.
    /// - Parameter checklist: The new to-do list.
    private func addChecklist(_ checklist: Checklist) {
        // Find the index for the new to-do list.
        let newRowIndex = lists.count
        
        // Add to-do list to `list` array.
        lists.append(checklist)
        
        // Let the table view know that there are new rows to be added.
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }
    
    /// Updates an existing to-do list in the `lists` array and updates the table view.
    /// - Parameter item: The modified to-do list.
    private func updateChecklist(_ checklist: Checklist) {
        // Find the index for the checklist in lists array.
        if let index = lists.firstIndex(of: checklist) {
            // Create an index path.
            let indexPath = IndexPath(row: index, section: 0)
            // Find the cell for edited item, and update the text.
            if let cell = tableView.cellForRow(at: indexPath) {
                configureText(for: cell, with: checklist)
            }
        }
    }
}
