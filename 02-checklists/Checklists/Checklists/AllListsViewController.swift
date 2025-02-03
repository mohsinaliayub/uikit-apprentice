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
        
        // Load checklists.
        loadChecklists()
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
    
    // MARK: - Data Persistence
        
    /// Returns a URL for the sandboxed Documents directory in the user domain.
    ///
    /// - Returns: URL for the Documents directory.
    func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    /// Returns a URL for the property list file to save/read Checklist objects.
    ///
    /// - Returns: A URL for the property list file.
    func dataFilePath() -> URL {
        documentsDirectory().appending(path: "Checklists.plist")
    }
    
    /// Saves Checklists into a property list file.
    func saveChecklists() {
        // Create a property list encoder.
        let encoder = PropertyListEncoder()
        
        do {
            // Encode checklist objects into data.
            let data = try encoder.encode(lists)
            
            // Save encoded data to file.
            try data.write(to: dataFilePath(), options: .atomic)
        } catch {
            print("Error encoding item array: \(error.localizedDescription)")
        }
    }
    
    /// Reads Checklist objects from a property list file, and loads them in ``lists`` array.
    func loadChecklists() {
        // Get the URL for property list file.
        let filePath = dataFilePath()
        
        // Read data from plist file
        if let data = try? Data(contentsOf: filePath) {
            // Create a decoder to decode binary data.
            let decoder = PropertyListDecoder()
            
            // Decode data and save it in our items array. Handle error if it fails.
            do {
                lists = try decoder.decode([Checklist].self, from: data)
            } catch {
                print("Error decoding item array: \(error.localizedDescription)")
            }
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
