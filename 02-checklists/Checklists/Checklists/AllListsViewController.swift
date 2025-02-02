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
    }
}

// MARK: - Table View Data Source

extension AllListsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        
        var cellConfiguration = UIListContentConfiguration.cell()
        cellConfiguration.text = "List \(indexPath.row)"
        cell.contentConfiguration = cellConfiguration
        
        return cell
    }
}

// MARK: - Table View Delegate

extension AllListsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Navigate to ChecklistViewController. Deselect the row.
        performSegue(withIdentifier: showChecklistSegueIdentifier, sender: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
