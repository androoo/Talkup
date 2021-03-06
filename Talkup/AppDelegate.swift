//
//  AppDelegate.swift
//  Talkup
//
//  Created by Andrew Ervin Gierke on 3/13/17.
//  Copyright © 2017 Androoo. All rights reserved.
//

import UIKit
import CloudKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
//        UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
//        UserDefaults.standard.synchronize()
        
        // Request notification permissions
        let unc = UNUserNotificationCenter.current()
        unc.requestAuthorization(options: [.alert, .badge, .sound]) { [weak self] (success, error) in
            if let error = error {
                NSLog("Error requesting authorization for notifications: \(error)")
                return
            }
        }
        
        UIApplication.shared.registerForRemoteNotifications()
        
        return true
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        let chatController = ChatController.shared
        chatController.performFullSync()
        
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    // check for new messages everytime app is reopened 
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        
        guard let unreadMessages = UserController.shared.currentUser?.unreadReferences else { return }
        
        MessageController.shared.fetchNewMessages(messages: unreadMessages, completion: {
            DispatchQueue.main.async {
                
                ChatController.shared.newMessagesCheck()
                
            }
        })
        
    }

}

