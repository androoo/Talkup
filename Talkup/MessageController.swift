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
    var messagesFilterState: MessageSort = .live 
    
    //MARK: - Initializers
    
    init() {
        self.cloudKitManager = CloudKitManager()
    }

    
    //MARK: - Fetch Messages 
    
    // all messages in chat
    
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
                
                // filter blocked messages
                
                DispatchQueue.main.async {
                    
                    chat.messages = messages
                    completion()
                    
                }
                
            }
        }
    }
    
    
    // new func to go search cloudkit for messages in array of chats, then set the messages to the chat array.
    
    func fetchMessagesIn(chats: [Chat], completion: @escaping () -> Void) {
        
        let chatReferences = chats.flatMap({$0.chatReference})
        
        let predicate = NSPredicate(format: "chat IN %@", chatReferences)
        
        let query = CKQuery(recordType: Constants.messagetypeKey, predicate: predicate)
        
        cloudKitManager.publicDatabase.perform(query, inZoneWith: nil) { (records, error) in
            
            if let error = error {
                print(error.localizedDescription)
                completion()
            } else {
                guard let records = records else { completion(); return }
                let messages = records.flatMap({Message(cloudKitRecord: $0)})
                
                for chat in chats {
                    for message in messages {
                        if message.chatReference.recordID == chat.cloudKitRecordID {
                            chat.messages.append(message)
                            completion()
                        }
                    }
                }
            }
        }
    }
    
    //MARK: - TODO: - this fetches all the messages
    
    func fetchNewMessages(messages: [CKReference], completion: @escaping () -> Void) {
        let messageReferences = messages
        guard messageReferences.count > 0 else { return }
        let predicate = NSPredicate(format: "recordID IN %@", messageReferences)
        let query = CKQuery(recordType: Constants.messagetypeKey, predicate: predicate)
        cloudKitManager.publicDatabase.perform(query, inZoneWith: nil) { (records, error) in
            if let error = error {
                print(error.localizedDescription)
                completion()
            } else {
                guard let records = records else { completion(); return }
                let messages = records.flatMap({Message(cloudKitRecord: $0)})
                UserController.shared.currentUser?.unreadMessages = messages
                ChatController.shared.newMessagesCheck()
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
        }
    }
    
    // Set Message's Chat
    
    func fetchMessageChatFor(messages: [Message], completion: @escaping () -> Void) {
        
        let chatReferences = messages.flatMap({$0.chatReference})
        
        let predicate = NSPredicate(format: "recordID IN %@", chatReferences)
        
        let query = CKQuery(recordType: Constants.chattypeKey, predicate: predicate)
        
        cloudKitManager.publicDatabase.perform(query, inZoneWith: nil) { (records, error) in
            
            if let error = error {
                print(error.localizedDescription)
                completion()
            } else {
                guard let records = records else { completion(); return }
                let chats = records.flatMap({Chat(cloudKitRecord: $0)})
                
                for message in messages {
                    if let chat = chats.filter({$0.cloudKitRecordID == message.chatReference.recordID}).first {
                        message.chat = chat
                    }
                }
                completion() 
            }
        }
        
    }
    
    
    func updateMessageScore(forMessage message: Message, completion: @escaping () -> Void) {

        let record = CKRecord(message: message)
        
            cloudKitManager.modifyRecords([record], perRecordCompletion: nil) { (records, error) in
                if let error = error {
                    print(error.localizedDescription)
                }
                completion()
        }
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


















