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
    /// The to-do items.
    private(set) var items: [ChecklistItem]
    
    init(name: String) {
        self.id = UUID()
        self.name = name
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
