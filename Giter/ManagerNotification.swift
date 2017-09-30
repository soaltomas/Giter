//
//  ManagerNotification.swift
//  Giter
//
//  Created by Артем Полушин on 24.09.17.
//  Copyright © 2017 Артем Полушин. All rights reserved.
//

import Foundation
import UserNotifications

class ManagerNotification {
    
    func sheduleNotification(inSeconds seconds: TimeInterval, completion: (Bool) -> ()) {
        
        removeNotifications(withIdentifiers: ["changeRepository"])
        
        let date = Date(timeIntervalSinceNow: seconds)
        let content = UNMutableNotificationContent()
        content.title = "Giter"
        content.body = "В ваших репозиториях произошли изменения."
        content.sound = UNNotificationSound.default()
        
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents([.month, .day, .hour, .minute, .second], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        let request = UNNotificationRequest(identifier: "changeRepository", content: content, trigger: trigger)
        
        let center = UNUserNotificationCenter.current()
        center.add(request, withCompletionHandler: nil)
    }
    
    func removeNotifications(withIdentifiers identifiers: [String]) {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: identifiers)
    }
    
}
