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
    private var checklists: [Checklist] {
        checklistManager.checklists
    }
    /// Manages a collection of checklists. Responsible for data persistence.
    var checklistManager: ChecklistsManager!
    
    // MARK: Outlets
    
    /// The table view to display and manage a list of To-do lists.
    @IBOutlet private weak var tableView: UITableView!
    
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Register a default cell.
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Reload data of tableview.
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Register our delegate.
        navigationController?.delegate = self
        
        // Reopen any Checklist if app was terminated when in background.
        showLastOpenedChecklist()
    }
    
    /// Navigates to last opened Checklist, if any.
    ///
    /// If the app was terminated when the user was on a Checklist, reopen that Checklist when user
    /// comes back to the app.
    private func showLastOpenedChecklist() {
        let index = checklistManager.indexOfSelectedChecklist
        // If index is in the range of checklist indices, then a Checklist was opened.
        if checklists.indices.contains(index) {
            let checklist = checklists[index]
            performSegue(withIdentifier: showChecklistSegueIdentifier, sender: checklist)
        }
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
        cellConfiguration.secondaryText = itemsRemainingCount()
        cellConfiguration.image = UIImage(named: checklist.iconName)
        
        cell.contentConfiguration = cellConfiguration
        
        func itemsRemainingCount() -> String {
            let uncheckedItemsCount = checklist.uncheckedItemsCount
            
            var itemCountText: String
            // If there are no items in checklist.
            if checklist.items.isEmpty {
                itemCountText = "(No Items)"
            } else {
                itemCountText = uncheckedItemsCount == 0 ? "All Done" : "\(uncheckedItemsCount) Remaining"
            }
            
            return itemCountText
        }
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
        return checklists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        
        let list = checklists[indexPath.row]
        
        configureText(for: cell, with: list)
        cell.accessoryType = .detailDisclosureButton
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        // Remove Checklist.
        checklistManager.removeChecklist(at: indexPath.row)
        // Remove the row from table view to keep it in sync with data.
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
}

// MARK: - Table View Delegate

extension AllListsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Navigate to ChecklistViewController. Deselect the row.
        let checklist = checklists[indexPath.row]
        
        performSegue(withIdentifier: showChecklistSegueIdentifier, sender: checklist)
        tableView.deselectRow(at: indexPath, animated: true)
        
        // Save the currently selected Checklist.
        checklistManager.indexOfSelectedChecklist = indexPath.row
    }
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        // Go to ListDetailViewController to edit a checklist
        let checklist = checklists[indexPath.row]
        performSegue(withIdentifier: editChecklistSegueIdentifier, sender: checklist)
    }
}

// MARK: - Navigation Controller Delegate

extension AllListsViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        // Was the back button tapped? If we move back to AllListsViewController,
        // remove the currently selected Checklist.
        if viewController === self {
            checklistManager.indexOfSelectedChecklist = -1
        }
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
    
    /// Adds a to-do list to the `checklists` array and updates the table view.
    /// - Parameter checklist: The new to-do list.
    private func addChecklist(_ checklist: Checklist) {
        // Add to-do list to `checklistManager` array.
        checklistManager.add(checklist)
        // Sort the checklists
        checklistManager.sortChecklists()
        
        // Let the table view know that there are new rows to be added.
        tableView.reloadData()
    }
    
    /// Updates an existing to-do list in the `checklists` array and updates the table view.
    /// - Parameter item: The modified to-do list.
    private func updateChecklist(_ checklist: Checklist) {
        // Update the checklists by sorting them.
        checklistManager.sortChecklists()
        
        // Let the table view know that there are new rows to be added.
        tableView.reloadData()
    }
}
