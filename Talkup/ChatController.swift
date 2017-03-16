//
//  ChatController.swift
//  Talkup
//
//  Created by Andrew Ervin Gierke on 3/13/17.
//  Copyright © 2017 Androoo. All rights reserved.
//

import Foundation
import CloudKit
import UIKit

extension ChatController {
    static let ChatsDidChangeNotification = Notification.Name("ChatsDidChangeNotification")
    static let ChatMessagesChangedNotification = Notification.Name("ChatMessagesChangedNotification")
}

class ChatController {
    
    //MARK: - Properties 
    
    static let shared = ChatController()
    
    let cloudKitManager: CloudKitManager
    
    var isSyncing: Bool = false
    
    var chats = [Chat]() {
        didSet {
            DispatchQueue.main.async {
                let nc = NotificationCenter.default
                nc.post(name: ChatController.ChatsDidChangeNotification, object: self)
            }
        }
    }

    var messages: [Message] {
        return chats.flatMap { $0.messages }
    }
    
    init() {
        self.cloudKitManager = CloudKitManager()
        performFullSync()
        
        subscribeToNewChats { (success, error) in
            if success {
                print("Successfully subscribed to new chats")
            }
        }
    }
    
    //MARK: - CK Methods
    
    func createChatWith(chatTopic: String, owner: String, firstMessage: String, completion: ((Chat) -> Void)?) {
        
        let chat = Chat(topic: chatTopic)
        chats.append(chat)
        let message = Message(owner: owner, text: firstMessage)
        
        cloudKitManager.saveRecord(CKRecord(chat: chat)) { (record, error) in
            guard let record = record else {
                if let error = error {
                    NSLog("Error saving new post to CloudKit: \(error)")
                    return
                }
                completion?(chat)
                return
            }
            chat.cloudKitRecordID = record.recordID
            
            // Save message record
            self.cloudKitManager.saveRecord(CKRecord(message: message)) { (record, error) in
                if let error = error {
                    NSLog("Error saving new comment to CloudKit: \(error)")
                    return
                }
                message.cloudKitRecordID = record?.recordID
                completion?(chat)
            }
            
            self.addSubscriptionTo(messagesForChat: chat, alertBody: "new comment on a chat! 👍") { (success, error) in
                if let error = error {
                    NSLog("Unable to save comment subscription: \(error)")
                }
            }
        }
    }
    
    @discardableResult func addMessage(toChat chat: Chat, messageText: String, completion: @escaping ((Message) -> Void) = { _ in }) -> Message {
        
        let message = Message(owner: "bob", text: messageText)
        chat.messages.append(message)
        
        cloudKitManager.saveRecord(CKRecord(message: message)) { (record, error) in
            if let error = error {
                NSLog("Error saving new comment to CloudKit: \(error)")
                return
            }
            message.cloudKitRecordID = record?.recordID
            completion(message)
        }
        
        DispatchQueue.main.async {
            let nc = NotificationCenter.default
            nc.post(name: ChatController.ChatMessagesChangedNotification, object: chat)
        }
        return message
    }
    
    func addSubscriptionTo(messagesForChat chat: Chat,
                           alertBody: String?,
                           completion: @escaping ((_ success: Bool, _ error: Error?) -> Void) = { _,_ in }) {
        
        guard let recordID = chat.cloudKitRecordID else { fatalError("Unable to create CloudKit reference for subscription.") }
        
        let predicate = NSPredicate(format: "chat == %@", argumentArray: [recordID])
        
        cloudKitManager.subscribe(Constants.messagetypeKey, predicate: predicate, subscriptionID: recordID.recordName, contentAvailable: true, alertBody: alertBody, desiredKeys: [Constants.messagetypeKey, Constants.messagesKey], options: .firesOnRecordCreation) { (subscription, error) in
            
            let success = subscription != nil
            completion(success, error)
        }
    }
    
    //MARK: - Helper Fetches
    
    private func recordsOf(type: String) -> [CloudKitSyncable] {
        switch type {
        case "Chat":
            return chats.flatMap { $0 as CloudKitSyncable }
        case "Message":
            return messages.flatMap { $0 as CloudKitSyncable }
        default:
            return []
        }
    }
    
    func syncedRecordsOf(type: String) -> [CloudKitSyncable] {
        return recordsOf(type: type).filter { $0.isSynced }
    }
    
    func unsyncedRecordsOf(type: String) -> [CloudKitSyncable] {
        return recordsOf(type: type).filter { !$0.isSynced }
    }
    
    
    func pushChangesToCloudKit(completion: @escaping ((_ success: Bool, _ error: Error?) -> Void) = { _,_ in }) {
        completion(false, nil)
    }
    
    //MARK: - Subscriptions
    
    func subscribeToNewChats(completion: @escaping ((_ success: Bool, _ error: Error?) -> Void) = { _,_ in }) {
        
        let predicate = NSPredicate(value: true)
        
        cloudKitManager.subscribe(Constants.chattypeKey, predicate: predicate, subscriptionID: "allChats", contentAvailable: true, options: .firesOnRecordCreation) { (subscription, error) in
            
            let success = subscription != nil
            completion(success, error)
        }
    }
    
    func checkSubscriptionTo(messagesForChat chat: Chat, completion: @escaping ((_ subscribed: Bool) -> Void) = { _ in }) {
        
        guard let subscriptionID = chat.cloudKitRecordID?.recordName else { completion(false)
            return
        }
        self.cloudKitManager.fetchSubscription(subscriptionID) { (subscription, error) in
            let subscribed = subscription != nil
            completion(subscribed)
        }
    }
    
    //MARK: - Sync
    
    func performFullSync(completion: @escaping (() -> Void) = { _ in }) {
        
        guard !isSyncing else {
            completion()
            return
        }
        isSyncing = true
        
        pushChangesToCloudKit { (success) in
            self.fetchNewRecordsOf(type: Constants.chattypeKey) {
                self.fetchNewRecordsOf(type: Constants.messagetypeKey) {
                    self.isSyncing = false
                    completion()
                }
            }
        }
    }
    
    func fetchNewRecordsOf(type: String, completion: @escaping (() -> Void) = { _ in }) {
        
        var referencesToExclude = [CKReference]()
        var predicate: NSPredicate!
        referencesToExclude = self.syncedRecordsOf(type: type).flatMap { $0.cloudKitReference }
        predicate = NSPredicate(format: "NOT(recordID IN %@)", argumentArray: [referencesToExclude])
        
        if referencesToExclude.isEmpty {
            predicate = NSPredicate(value: true)
        }
        
        cloudKitManager.fetchRecordsWithType(type, predicate: predicate, recordFetchedBlock: { (record) in
            
            switch type {
            case Constants.chattypeKey:
                if let chat = Chat(cloudKitRecord: record) {
                    self.chats.append(chat)
                }
            case Constants.messagetypeKey:
                guard let chatReference = record[Constants.chatKey] as? CKReference,
                    let chatIndex = self.chats.index(where: { $0.cloudKitRecordID == chatReference.recordID }),
                    let message = Message(cloudKitRecord: record) else { return }
                let chat = self.chats[chatIndex]
                chat.messages.append(message)
                
            default:
                return
            }
            
        }) { (records, error) in
            
            if let error = error {
                NSLog("Error fetching CloudKit records of type \(type): \(error)")
            }
            
            completion()
        }
    }
}

















