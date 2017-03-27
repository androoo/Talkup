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
    
    //MARK: - Fetch Messages 
    
    func fetchMessagesIn(chat: Chat, completion: @escaping () -> Void) {
        guard let chatRecordID = chat.cloudKitRecordID else { return }
        
        let predicate = NSPredicate(format: "chat == %@", chatRecordID)
        
        let query = CKQuery(recordType: Constants.messagetypeKey, predicate: predicate)
        
        cloudKitManager.publicDatabase.perform(query, inZoneWith: nil) { (records, error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                guard let records = records else { return }
                
                let messages = records.flatMap({Message(cloudKitRecord: $0)})
                
                // Get the owner for each message
                
                chat.messages = messages
                completion()
                
            }
        }
    }
    
    // Set Message Owner
    
    func fetchMessageOwnersFor(messages: [Message], completion: @escaping () -> Void) {
        let ownerReferences = messages.flatMap({$0.ownerReference})
        
        let predicate = NSPredicate(format: "recordID IN %@", ownerReferences)
        
        let query = CKQuery(recordType: Constants.usertypeKey, predicate: predicate)
        
        cloudKitManager.publicDatabase.perform(query, inZoneWith: nil) { (records, error) in
            
            if let error = error {
                print(error.localizedDescription)
                completion()
            } else {
                
                guard let records = records else { completion(); return }
                
                let owners = records.flatMap({User(cloudKitRecord: $0)})
                
                for message in messages {
                    if let owner = owners.filter({$0.cloudKitRecordID == message.ownerReference.recordID}).first {
                        message.owner = owner
                    }
                }
                completion()
            }
            // if Message's ownerRef matches 
            
            //flat map user 
            //check if the message matches owner 
            //set the owner to message owner
        }
    }
    
    func increaseScoreForMessage(messageNamed message: Message,
                                 completion: @escaping ((_ success: Bool, _ error: Error?) -> Void) = { _,_ in }) {

//        message.score += 1
//        
//        ChatController.shared.pushChangesToCloudKit()
        
    }

    
    
    func toggleVoteCountFor(messageNamed message: Message, completion: @escaping ((_ success: Bool, _ isSubscribed: Bool, _ error: Error?) -> Void) = { _, _, _ in }) {
        
//        guard let messageID = message.cloudKitRecordID?.recordName else {
//            completion(false, false, nil)
//            return
//        }
//        
//        print("attempting to toggle score for \(message.text)")
//        
//        cloudKitManager.fetchSubscription(messageID) { (subscription, error) in
//            
//            if subscription != nil {
//                self.reduceScoreForMessage(messageNamed: message) { (success, error) in
//                    print("subsribed message, so decrease and unsub")
//                    completion(success, false, error)
//                }
//            } else {
//                self.increaseScoreForMessage(messageNamed: message) { (success, error) in
//                    print("unsubscribed, so increase and subscribe")
//                    completion(success, true, error)
//                }
//            }
//        }
    }
    
    //MARK: - Message Subscriptions 
    
    
    func checkSubscriptionTo(messageNamed message: Message, completion: @escaping ((_ subscribed: Bool) -> Void ) = { _ in }) {
        
        guard let subscriptionID = message.cloudKitRecordID?.recordName else {
            completion(false)
            return
        }
        
        cloudKitManager.fetchSubscription(subscriptionID) { (subscription, error) in
            let subscribed = subscription != nil
            completion(subscribed)
        }
    }
    
    func addSubscriptionTo(messageNamed message: Message, alertBody: String?,
                           completion: @escaping ((_ success: Bool, _ error: Error?) -> Void) = { _,_ in }){
        
        guard let recordID = message.cloudKitRecordID else { fatalError("unable to create reference for subscription") }
        
        let predicate = NSPredicate(format: "recordID == %@", argumentArray: [recordID])
        
        cloudKitManager.subscribe(Constants.messagetypeKey, predicate: predicate, subscriptionID: recordID.recordName, contentAvailable: true, alertBody: alertBody, desiredKeys: [Constants.textKey, Constants.chatKey], options: .firesOnRecordCreation) { (subscription, error) in
            
            let success = subscription != nil
            completion(success, error)
        }
    }
    
    
    func removeSubscriptionTo(messageNamed message: Message,
                              completion: @escaping ((_ success: Bool, _ error: Error?) -> Void) = { _,_ in }) {
        
        guard let subscriptionID = message.cloudKitRecordID?.recordName else {
            completion(true, nil)
            return
        }
        
        cloudKitManager.unsubscribe(subscriptionID) { (subscriptionID, error) in
            let success = subscriptionID != nil && error == nil
            completion(success, error)
        }
    }
    
    
    func toggleSubscriptionTo(messageNamed message: Message,
                              completion: @escaping ((_ success: Bool, _ isSubscribed: Bool, _ error: Error?) -> Void) = { _,_,_ in }) {
        
        guard let subscriptionID = message.cloudKitRecordID?.recordName else {
            completion(false, false, nil)
            return
        }
        
        cloudKitManager.fetchSubscription(subscriptionID) { (subscription, error) in
            
            if subscription != nil {
                self.removeSubscriptionTo(messageNamed: message) { (success, error) in
                    message.score -= 1
                    completion(success, false, error)
                }
            } else {
                self.addSubscriptionTo(messageNamed: message, alertBody: "Someone commented on a message you voted for! 👍") { (success, error) in
                    message.score += 1
                    completion(success, true, error)
                }
            }
        }
    }
}


















