//
//  AppDelegate.swift
//  Giter
//
//  Created by Артем Полушин on 09.07.17.
//  Copyright © 2017 Артем Полушин. All rights reserved.
//

import UIKit
import Firebase
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var oldRepoList: [RepoData] = []
    var newRepoList: [RepoData] = []
    var repoForNotification: [String] = []


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            
        }
        
        return true
    }
    
    func sendNotification(isSecond seconds: TimeInterval) {
        let content = UNMutableNotificationContent()
        content.title = "Giter"
        content.body = "Ваши репозитории изменились"
        content.sound = UNNotificationSound.default()
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents([.month, .day, .hour, .minute, .second], from: Date(timeIntervalSinceNow: seconds))
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        let request = UNNotificationRequest(identifier: "identifier", content: content, trigger: trigger)
        
        let center = UNUserNotificationCenter.current()
        center.add(request, withCompletionHandler: nil)
    }
    
    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        if lastUpdate != nil && abs(lastUpdate!.timeIntervalSinceNow) < 30 {
            completionHandler(.noData)
            return
        }
        func complite() {
            
        }
        
        
        timer = DispatchSource.makeTimerSource(queue: DispatchQueue.main)
        timer?.scheduleRepeating(deadline: .now(), interval: .seconds(29), leeway: .seconds(1))
        timer?.setEventHandler {
            completionHandler(.failed)
            return
        }
        timer?.resume()
        
        for repo in ManagerData.singleManager.repoData {
            oldRepoList.append(repo)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateTable), name: NSNotification.Name(rawValue: "updateTable"), object: nil)
        
        ManagerData.singleManager.loadRepoJSON()
        
    
       /* for _ in ManagerData.singleManager.repoData {
            ManagerData.singleManager.loadRepoJSON()
        }*/
        
        lastUpdate = Date()
        timer = nil
        completionHandler(.newData)
        return
    }
    
    func updateTable() {
        ManagerData.singleManager.getRepoDataFromDB()
        
        for repo in ManagerData.singleManager.repoData {
            newRepoList.append(repo)
        }
        
        if oldRepoList.count != newRepoList.count {
            sendNotification(isSecond: 5)
        } else {
            for oldRep in oldRepoList {
                for newRep in newRepoList {
                    if oldRep.name == newRep.name && oldRep.createdDate != newRep.createdDate {
                        repoForNotification.append(newRep.name)
                        sendNotification(isSecond: 5)
                    }
                }
            }
        }
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

