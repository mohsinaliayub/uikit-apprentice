//
//  AddItemViewController.swift
//  Checklists
//
//  Created by Mohsin Ali Ayub on 26.01.25.
//

import UIKit

class AddItemViewController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Actions
    
    @IBAction private func cancel() {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction private func done() {
        navigationController?.popViewController(animated: true)
    }
}
