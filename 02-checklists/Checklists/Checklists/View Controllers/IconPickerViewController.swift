//
//  IconPickerViewController.swift
//  Checklists
//
//  Created by Mohsin Ali Ayub on 05.02.25.
//

import UIKit

/// Methods for managing the picking of an icon name.
protocol IconPickerViewControllerDelegate: AnyObject {
    /// Tells the delegate the ``IconPickerViewController`` finished picking an icon name.
    /// - Parameters:
    ///   - controller: An `IconPickerViewController` telling the delegate about the impending pickup of an icon.
    ///   - iconName: The icon name of an image included in the assets catalog.
    func iconPicker(_ controller: IconPickerViewController, didPick iconName: String)
}

class IconPickerViewController: UITableViewController {
    /// An array of image names included in the asset catalog.
    private let icons = [
        "No Icon", "Appointments", "Birthdays", "Chores",
        "Drinks", "Folder", "Groceries", "Inbox", "Photos", "Trips"
    ]
    /// A cell reuse identifier.
    private let cellIdentifier = "IconCell"
    
    /// A delegate informing the pickup of an icon name.
    weak var delegate: IconPickerViewControllerDelegate?
    
    // MARK: - Table View Data Source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        icons.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        
        displayIconAndName(in: cell, for: indexPath)
        
        return cell
    }
    
    /// Displays an icon and name for a table view cell.
    private func displayIconAndName(in cell: UITableViewCell, for indexPath: IndexPath) {
        let iconName = icons[indexPath.row]
        
        var contentConfiguration = UIListContentConfiguration.cell()
        contentConfiguration.text = iconName
        contentConfiguration.image = UIImage(named: iconName)
        cell.contentConfiguration = contentConfiguration
    }
}
