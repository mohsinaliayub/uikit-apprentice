//
//  ChecklistItem.swift
//  Checklists
//
//  Created by Mohsin Ali Ayub on 26.01.25.
//

import Foundation

/// A simple to-do item to be performed by the user.
///
/// You can and should specify a unique title for your to-do item to be easily identified among others.
/// The to-do item can be set as complete/uncomplete.
class ChecklistItem {
    /// A name to identify a to-do item. Please specify a unique name to easily identify the to-do item.
    var title: String
    /// The state of the to-do item, whether it is completed or not.
    var checked: Bool
    
    /// Initializes a `ChecklistItem` object with both ``title`` and ``checked`` states.
    /// - Parameters:
    ///   - title: The unique title to identify a to-do item.
    ///   - checked: The state of the to-do item: completed or not.
    init(title: String, checked: Bool) {
        self.title = title
        self.checked = checked
    }
    
    
    /// Initializes a `ChecklistItem` object with a title and a default ``checked`` state as `false`.
    /// - Parameter title: The unique title to identify a to-do item.
    convenience init(title: String) {
        self.init(title: title, checked: false)
    }
}
