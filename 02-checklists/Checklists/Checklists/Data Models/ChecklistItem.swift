//
//  ChecklistItem.swift
//  Checklists
//
//  Created by Mohsin Ali Ayub on 26.01.25.
//

import Foundation
import UserNotifications

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
    
    // Remove pending notification when object is removed from memory, if any.
    deinit {
        removePendingNotification()
    }
    
    /// Schedule a local notification for todo item on due date.
    func scheduleNotification() {
        // Remove a pending notification, if there was one.
        removePendingNotification()
        
        // Schedule it only if dueDate is in the future and shouldRemind is true.
        guard let dueDate, shouldRemind && dueDate > Date() else { return }
        
        // Create notification content, calendar trigger, create a request.
        let content = notificationContent()
        let trigger = notificationTrigger(for: dueDate)
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        
        // Schedule the notification with notification center.
        let center = UNUserNotificationCenter.current()
        center.add(request)
    }
    
    /// Creates a mutable notification content with title, body and a default notification sound.
    private func notificationContent() -> UNMutableNotificationContent {
        let content = UNMutableNotificationContent()
        content.title = "Reminder:"
        content.body = text
        content.sound = .default
        
        return content
    }
    
    /// Creates a calendar notification trigger on specified date.
    ///
    /// - Parameter dueDate: The date on which to schedule a notification.
    private func notificationTrigger(for dueDate: Date) -> UNCalendarNotificationTrigger {
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: dueDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        
        return trigger
    }
    
    /// Removes a pending notification for this todo item, if any.
    private func removePendingNotification() {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: [id])
    }
}

extension ChecklistItem: Equatable {
    static func == (lhs: ChecklistItem, rhs: ChecklistItem) -> Bool {
        lhs.id == rhs.id
    }
}
