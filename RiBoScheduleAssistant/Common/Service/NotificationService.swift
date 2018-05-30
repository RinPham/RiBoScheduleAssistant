//
//  NotificationService.swift
//  RiBoScheduleAssistant
//
//  Created by Rin Pham on 5/22/18.
//  Copyright © 2018 Rin Pham. All rights reserved.
//

import Foundation
import UserNotifications

class NotificationService {
    
    static func confureNotification(task: Task) {

        let content = UNMutableNotificationContent()
        content.body = "You have a reminder: \(task.title)."
        content.sound = UNNotificationSound.default()
        // Create the request object.
        var request = UNNotificationRequest(identifier: "reminder_" + task.id, content: content, trigger: nil)
        switch task.repeatType {
        case .none:
            if task.time > Date() {
                let dateInfo = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute,], from: task.time)
                let trigger = UNCalendarNotificationTrigger(dateMatching: dateInfo, repeats: false)
                request = UNNotificationRequest(identifier: "reminder_" + task.id, content: content, trigger: trigger)
            }
        case .daily:
            let dateInfo = Calendar.current.dateComponents([.hour, .minute], from: task.time)
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateInfo, repeats: true)
            request = UNNotificationRequest(identifier: "reminder_" + task.id, content: content, trigger: trigger)
        case .weekdays:
            for i in 0...2 {
                let date = Date().adjust(DateComponentType.day, offset: i)
                if date.compare(.isWeekday), let number = Calendar.current.dateComponents([.day], from: task.time, to: date).day {
                    let dateTask = task.time.adjust(.day, offset: number)
                    let dateInfo = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: dateTask)
                    let trigger = UNCalendarNotificationTrigger(dateMatching: dateInfo, repeats: false)
                    request = UNNotificationRequest(identifier: "reminder_" + task.id, content: content, trigger: trigger)
                }
            }
        case .weekends:
            for i in 0...2 {
                let date = Date().adjust(DateComponentType.day, offset: i)
                if date.compare(.isWeekend), let number = Calendar.current.dateComponents([.day], from: task.time, to: date).day {
                    let dateTask = task.time.adjust(.day, offset: number)
                    let dateInfo = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: dateTask)
                    let trigger = UNCalendarNotificationTrigger(dateMatching: dateInfo, repeats: false)
                    request = UNNotificationRequest(identifier: "reminder_" + task.id, content: content, trigger: trigger)
                }
            }
        case .weekly:
            let dateInfo = Calendar.current.dateComponents([.weekday,.hour, .minute], from: task.time)
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateInfo, repeats: true)
            request = UNNotificationRequest(identifier: "reminder_" + task.id, content: content, trigger: trigger)
        case .monthly:
            let dateInfo = Calendar.current.dateComponents([.day,.hour, .minute], from: task.time)
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateInfo, repeats: true)
            request = UNNotificationRequest(identifier: "reminder_" + task.id, content: content, trigger: trigger)
        }
        
        print("ADD NOTIFICATION REMIDER: \(request.trigger)")
        let center = UNUserNotificationCenter.current()
        center.add(request) { (error : Error?) in
            if let theError = error {
                print(theError.localizedDescription)
            }
        }
        DispatchQueue.main.async {
            UIApplication.shared.registerForRemoteNotifications()
        }
    }
    
    static func confureNotification(event: Event) {
        guard event.startDate > Date() else {
            return
        }
        let message = "You have a event \(event.title) from \(event.startDate.toDateAndTimeString) to \(event.endDate.toDateAndTimeString)."
        let content = UNMutableNotificationContent()
        content.body = NSString.localizedUserNotificationString(forKey: message, arguments: nil)
        
        let dateInfo = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: event.startDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateInfo, repeats: false)
        
        // Create the request object.
        let request = UNNotificationRequest(identifier: "event_" + event.id, content: content, trigger: trigger)
        print("ADD NOTIFICATION EVENT: \(request.trigger)")
        let center = UNUserNotificationCenter.current()
        center.add(request) { (error : Error?) in
            if let theError = error {
                print(theError.localizedDescription)
            }
        }
        DispatchQueue.main.async {
            UIApplication.shared.registerForRemoteNotifications()
        }
    }
    
    static func cancelNotification(task: Task) {
        let id = "reminder_" + task.id
        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: [id])
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id])
    }
    
    static func cancelNotification(event: Event) {
        let id = "event_" + event.id
        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: [id])
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id])
    }
    
    static func cancelAllNotification() {
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
}
