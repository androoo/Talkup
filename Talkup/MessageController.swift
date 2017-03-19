//
//  MessageController.swift
//  Talkup
//
//  Created by Andrew Ervin Gierke on 3/13/17.
//  Copyright © 2017 Androoo. All rights reserved.
//

import Foundation
import CloudKit



class MessageController {
    
    //MARK: - Properties
    
    let cloudKitManager: CloudKitManager

    static let shared = MessageController()
    
    //MARK: - Initializers
    
    init() {
        self.cloudKitManager = CloudKitManager()
    }
    
    func increaseScoreForMessage(messageNamed message: Message,
                                 completion: @escaping ((_ success: Bool, _ error: Error?) -> Void) = { _,_ in }) {
        
        guard let recordID = message.cloudKitRecordID else { fatalError("Unable to create CloudKit reference for message.") }
        
        let predicate = NSPredicate(format: "message == %@", argumentArray: [recordID])
        
        cloudKitManager.subscribe(Constants.messagetypeKey, predicate: predicate, subscriptionID: recordID.recordName, contentAvailable: true, desiredKeys: [Constants.messagetypeKey], options: .firesOnRecordCreation) { (subscription, error) in
            
            let success = subscription != nil
            completion(success, error)
        }
        
        message.score += 1
        
        ChatController.shared.pushChangesToCloudKit()
        
    }
    
    
    func reduceScoreForMessage(messageNamed message: Message,
                               completion: @escaping ((_ success: Bool, _ error: Error?) -> Void) = { _,_ in }) {

        if message.score > 0 {
            message.score -= 1
            
            guard let subscriptionID = message.cloudKitRecordID?.recordName else {
                completion(true, nil)
                return
            }
            
            cloudKitManager.unsubscribe(subscriptionID) { (subscriptionID, error) in
                let success = subscriptionID != nil && error == nil
                completion(success, error)
            }
            
            ChatController.shared.pushChangesToCloudKit()
        }
    }
    
    
    func toggleVoteCountFor(messageNamed message: Message, completion: @escaping ((_ success: Bool, _ isSubscribed: Bool, _ error: Error?) -> Void) = { _, _, _ in }) {
        
        guard let messageID = message.cloudKitRecordID?.recordName else {
            completion(false, false, nil)
            return
        }
        
        print("attempting to toggle score for \(message.text)")
        
        cloudKitManager.fetchSubscription(messageID) { (subscription, error) in
            
            if subscription != nil {
                self.reduceScoreForMessage(messageNamed: message) { (success, error) in
                    print("subsribed message, so decrease and unsub")
                    completion(success, false, error)
                }
            } else {
                self.increaseScoreForMessage(messageNamed: message) { (success, error) in
                    print("unsubscribed, so increase and subscribe")
                    completion(success, true, error)
                }
            }
        }
    }
}


















