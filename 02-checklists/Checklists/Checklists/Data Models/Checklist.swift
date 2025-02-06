//
//  Checklist.swift
//  Checklists
//
//  Created by Mohsin Ali Ayub on 02.02.25.
//

import Foundation

/// A To-do list.
///
/// Specify a unique name to easily identify a to-do list later. Each to-do list has multiple to-do
/// items related to it.
final class Checklist {
    /// A unique identifier for to-do list.
    private let id: UUID
    /// The name to identify a to-do list. Specifying a unique name will easily identify the to-do list.
    var name: String
    /// Icon name from app's asset catalog.
    ///
    /// The default icon name is "No Icon".
    var iconName: String
    /// The to-do items.
    private(set) var items: [ChecklistItem]
    /// The number of todo items the user has not completed.
    var uncheckedItemsCount: Int {
        items.filter({ !$0.checked }).count
    }
    
    /// Initializes a `Checklist` object with both `name` and `iconName`.
    /// - Parameters:
    ///   - name: A name to identify a to-do list.
    ///   - iconName: The name of an image included in the app's asset catalog. The default is `No Icon`.
    init(name: String, iconName: String = "No Icon") {
        self.id = UUID()
        self.name = name
        self.iconName = iconName
        self.items = []
    }
    
    /// Removes a to-do item at specified index.
    ///
    /// - Parameter index: The position of the to-do item to remove. index must be a valid index of the array.
    func removeItem(at index: Int) {
        items.remove(at: index)
    }
    
    /// Adds a to-do item to this checklist.
    ///
    /// - Parameter item: The to-do item to add to checklist.
    func addItem(_ item: ChecklistItem) {
        items.append(item)
    }
}

extension Checklist: Equatable {
    static func == (lhs: Checklist, rhs: Checklist) -> Bool {
        // Each Checklist has a unique id. If id's are same, Checklist is same.
        lhs.id == rhs.id
    }
}

extension Checklist: Codable { }

extension Checklist: Comparable {
    static func < (lhs: Checklist, rhs: Checklist) -> Bool {
        lhs.name.localizedStandardCompare(rhs.name) == .orderedAscending
    }
}
