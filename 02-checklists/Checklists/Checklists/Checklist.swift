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
class Checklist {
    /// A unique identifier for to-do list.
    private let id = UUID()
    /// The name to identify a to-do list. Specifying a unique name will easily identify the to-do list.
    var name: String
    /// An array of to-do items.
//    var items = [ChecklistItem]()
    
    init(name: String) {
        self.name = name
    }
}

extension Checklist: Equatable {
    static func == (lhs: Checklist, rhs: Checklist) -> Bool {
        // Each Checklist has a unique id. If id's are same, Checklist is same.
        lhs.id == rhs.id
    }
}
