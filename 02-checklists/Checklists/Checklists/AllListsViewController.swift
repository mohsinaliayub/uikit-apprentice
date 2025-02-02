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
    /// A collection of to-do lists. Each to-do list has multiple to-do items in it.
    private var lists = [Checklist]()
    
    // MARK: Outlets
    
    /// The table view to display and manage a list of To-do lists.
    @IBOutlet private weak var tableView: UITableView!
    
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
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showChecklistSegueIdentifier {
            // Populate necessary properties to work on.
            let checklistVC = segue.destination as! ChecklistViewController
            checklistVC.checklist = sender as? Checklist
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
        
        var cellConfiguration = UIListContentConfiguration.cell()
        cellConfiguration.text = list.name
        
        cell.contentConfiguration = cellConfiguration
        cell.accessoryType = .detailDisclosureButton
        
        return cell
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
}
