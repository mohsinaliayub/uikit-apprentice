//
//  ChecklistViewController.swift
//  Checklists
//
//  Created by Mohsin Ali Ayub on 25.01.25.
//

import UIKit

class ChecklistViewController: UITableViewController {
    
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
        return cell
    }
}

