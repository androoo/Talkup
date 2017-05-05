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
    var currentUser: User?
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
    
    //MARK: - Set Chat's Creator
    
    func fetchChatOwnersFor(chats: [Chat], completion: @escaping () -> Void) {
        
        let creatorReferences = chats.flatMap({$0.creatorReference})
        
        let predicate = NSPredicate(format: "recordID IN %@", creatorReferences)
        let query = CKQuery(recordType: Constants.usertypeKey, predicate: predicate)
        
        cloudKitManager.publicDatabase.perform(query, inZoneWith: nil) { (records, error) in
            if let error = error {
                print(error.localizedDescription)
                completion()
            } else {
                guard let records = records else { completion(); return }
                
                let creators = records.flatMap({User(cloudKitRecord: $0)})
                
                for chat in chats {
                    if let creator = creators.filter({$0.cloudKitRecordID == chat.creatorReference.recordID}).first {
                        chat.creator = creator
                    }
                }
                
                completion()
            }
        }
    }
    
    
    //MARK: - CK Methods
    
    func createChatWith(chatTopic: String, owner: User, firstMessage: String, completion: ((Chat) -> Void)?) {
        
        guard let creatorRef = UserController.shared.currentUser?.cloudKitReference else { return }
        
        let chat = Chat(creatorReference: creatorRef, topic: chatTopic)
        chat.creator = owner
        chats.append(chat)
        
        let chatRecord = CKRecord(chat: chat)
        
        chat.cloudKitRecordID = chatRecord.recordID
        
        guard let ownerReference = owner.cloudKitReference,
            let chatReference = chat.cloudKitReference else { return }
        
        let message = Message(ownerReference: ownerReference, text: firstMessage, chatReference: chatReference)
        
        cloudKitManager.saveRecord(chatRecord) { (record, error) in
            guard let record = record else {
                if let error = error {
                    NSLog("Error saving new post to CloudKit: \(error)")
                    return
                }
                completion?(chat)
                return
            }
            chat.cloudKitRecordID = record.recordID
            
            // And Save message record
            
            self.cloudKitManager.saveRecord(CKRecord(message: message)) { (record, error) in
                if let error = error {
                    NSLog("Error saving new comment to CloudKit: \(error)")
                    return
                }
                message.cloudKitRecordID = record?.recordID
                
                self.addSubscriptionTo(messagesForChat: chat, alertBody: "New 💬 on a chat! 🙏 ") { (success, error) in
                    if let error = error {
                        NSLog("Unable to save comment subscription: \(error)")
                    }
                    chat.messages.append(message)
                    completion?(chat)
                }

            }
            
            
        }
    }
    
    @discardableResult func addMessage(byUser owner: User, toChat chat: Chat, messageText: String, completion: @escaping ((Message) -> Void) = { _ in }) -> Message {
        
        let ownerReference = owner.cloudKitReference
        let chatReference = chat.cloudKitReference
        
        let message = Message(ownerReference: ownerReference!, text: messageText, chatReference: chatReference!)
        chat.messages.append(message)
        
        cloudKitManager.saveRecord(CKRecord(message: message)) { (record, error) in
            if let error = error {
                NSLog("Error saving new comment to CloudKit: \(error)")
                return
            }
            message.cloudKitRecordID = record?.recordID
            
            DispatchQueue.main.async {
                let nc = NotificationCenter.default
                nc.post(name: ChatController.ChatMessagesChangedNotification, object: chat)
            }
            
            message.owner = owner
            
            completion(message)
        }
        return message
    }
    
    
    func addSubscriptionTo(messagesForChat chat: Chat,
                           alertBody: String?,
                           completion: @escaping ((_ success: Bool, _ error: Error?) -> Void) = { _,_ in }) {
        
        guard let recordID = chat.cloudKitRecordID else { fatalError("Unable to create CloudKit reference for subscription.") }
        
        let predicate = NSPredicate(format: "chat == %@", argumentArray: [recordID])
        
        cloudKitManager.subscribe(Constants.messagetypeKey, predicate: predicate, subscriptionID: recordID.recordName, contentAvailable: true, alertBody: alertBody, desiredKeys: [Constants.textKey], options: .firesOnRecordCreation) { (subscription, error) in
            
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
        
        let unsavedChats = unsyncedRecordsOf(type: Constants.chattypeKey) as? [Chat] ?? []
        let unsavedMessages = unsyncedRecordsOf(type: Constants.messagetypeKey) as? [Message] ?? []
        var unsavedObjectsByRecord = [CKRecord: CloudKitSyncable]()
        for chat in unsavedChats {
            let record = CKRecord(chat: chat)
            unsavedObjectsByRecord[record] = chat
        }
        for message in unsavedMessages {
            let record = CKRecord(message: message)
            unsavedObjectsByRecord[record] = message
        }
        
        let unsavedRecords = Array(unsavedObjectsByRecord.keys)
        
        cloudKitManager.saveRecords(unsavedRecords, perRecordCompletion: { (record, error) in
            
            guard let record = record else { return }
            unsavedObjectsByRecord[record]?.cloudKitRecordID = record.recordID
            
        }) { (records, error) in
            
            let success = records != nil
            completion(success, error)
        }
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
        cloudKitManager.fetchSubscription(subscriptionID) { (subscription, error) in
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
                self.fetchChatOwnersFor(chats: self.chats, completion: { 
                    
                    self.isSyncing = false
                    NotificationCenter.default.post(name: Notification.Name("syncingComplete"), object: nil)
                    completion()
                })
                
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
                message.chat = chat
                
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





/*
 
 christians subscirption stuff
 
 func subscribeToStudentReadyCheck(topic: Topic) {
 guard let topicID = topic.recordID else { return }
 let topifRef = CKReference(recordID: topicID, action: .none)
 let notificationInfo = CKNotificationInfo()
 let topicPredicate = NSPredicate(format: "topicReferences CONTAINS %@", topifRef)
 notificationInfo.shouldSendContentAvailable = true
 let predicates = NSCompoundPredicate(andPredicateWithSubpredicates: [topicPredicate])
 
 
 let subscription = CKQuerySubscription(recordType: "User", predicate: predicates, options: .firesOnRecordUpdate)
 subscription.notificationInfo = notificationInfo
 
 subscribe("User", predicate: predicates, subscriptionID: "studentReadyCheck", contentAvailable: true, options: .firesOnRecordUpdate) { (_, _) in
 
 }
 
 }
 
 func subscribeToStudentQuestion(topic: Topic) {
 let notificationInfo = CKNotificationInfo()
 guard let topicID = topic.recordID else { return }
 let predicate = NSPredicate(format: "topicReference == %@", topicID)
 notificationInfo.shouldSendContentAvailable = true
 
 let subscription = CKQuerySubscription(recordType: "Question", predicate: predicate, options: .firesOnRecordCreation)
 subscription.notificationInfo = notificationInfo
 
 subscribe("Question", predicate: predicate, subscriptionID: "NewQuestion", contentAvailable: true, options: .firesOnRecordCreation) { (_, _) in
 
 }
 subscribe("Question", predicate: predicate, subscriptionID: "DeletedQuestion", contentAvailable: true, options: .firesOnRecordDeletion) { (_, _) in
 
 }
 
 }
 
 func subscribeToQuestionVotesIn(topic: Topic) {
 
 guard let topicID = topic.recordID else { return }
 let questionPredicate = NSPredicate(value: true)
 let topicRefPredicate = NSPredicate(format: "topicReference == %@", topicID)
 let predicates = NSCompoundPredicate(andPredicateWithSubpredicates: [questionPredicate, topicRefPredicate])
 
 subscribe("Question", predicate: predicates, subscriptionID: "QuestionVote", contentAvailable: true, options: .firesOnRecordUpdate) { (_, _) in
 
 }
 }
 
 
 
 func subscribeToTopicBool(topic: Topic) {
 let notificationInfo = CKNotificationInfo()
 
 guard let topicID = topic.recordID else { return }
 let topicIDPredicate = NSPredicate(format: "recordID == %@", topicID)
 let predicates = NSCompoundPredicate(andPredicateWithSubpredicates: [topicIDPredicate])
 notificationInfo.shouldSendContentAvailable = true
 let subscription = CKQuerySubscription(recordType: "Topic", predicate: predicates, options: .firesOnRecordUpdate)
 subscription.notificationInfo = notificationInfo
 
 subscribe("Topic", predicate: predicates, subscriptionID: "Topic", contentAvailable: true, options: .firesOnRecordUpdate) { (_, _) in
 
 }
 }
 
 */











