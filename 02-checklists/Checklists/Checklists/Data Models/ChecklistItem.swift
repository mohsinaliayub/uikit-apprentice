//
//  ChecklistItem.swift
//  Checklists
//
//  Created by Mohsin Ali Ayub on 26.01.25.
//

import Foundation

/// A simple to-do item to be performed by the user.
///
/// You can and should specify a unique description for your to-do item to be easily identified among others.
/// The to-do item can be set as complete/uncomplete.
class ChecklistItem: Codable {
    /// A unique identifier for to-do item.
    private let id: String
    /// A description to identify a to-do item. Please specify a unique description to easily identify the to-do item.
    var text: String
    /// The state of the to-do item, whether it is completed or not.
    var checked: Bool
    /// State to describe whether to schedule a local notification for this object, or not.
    var shouldRemind: Bool
    /// A date (with time) on which to schedule the notification.
    var dueDate: Date?
    
    /// Initializes a `ChecklistItem` object with both ``text`` and ``checked`` states.
    /// - Parameters:
    ///   - text: A unique description to identify a to-do item.
    ///   - checked: The state of the to-do item: completed or not.
    init(text: String, checked: Bool) {
        self.id = UUID().uuidString
        self.text = text
        self.checked = checked
        self.shouldRemind = false
    }
    
    
    /// Initializes a `ChecklistItem` object with a description and a default ``checked`` state as `false`.
    /// - Parameter title: A unique description to identify a to-do item.
    convenience init(text: String) {
        self.init(text: text, checked: false)
    }
}

extension ChecklistItem: Equatable {
    static func == (lhs: ChecklistItem, rhs: ChecklistItem) -> Bool {
        lhs.id == rhs.id
    }
}
