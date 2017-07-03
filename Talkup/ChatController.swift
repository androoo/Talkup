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
    
    var followingChats = [Chat]() {
        didSet {
            
        }
    }
    
    var messages: [Message] {
        return chats.flatMap { $0.messages }
    }
    
    var unreadMessages: [Message]?
    var chatLastVisitLog: [String: String] = [:]
    
    
    init() {
        self.cloudKitManager = CloudKitManager()
        
        guard let user = UserController.shared.currentUser else { return }
        
        performFullSync()
        
        subscribeToNewChats { (success, error) in
            if success {
                print("Successfully subscribed to new chats")
            }
        }
        
    }
    
    //MARK: - Following stuff
    
    
    func populateFollowingChats() {
        
        guard let user = UserController.shared.currentUser,
            let records = user.following else { return }
        
        let followingChatRecordNames = records.flatMap({$0.recordID.recordName})
//        let chatRecordNames = chats.flatMap({$0.chatReference?.recordID.recordName})
        
        for chat in chats {
            for id in followingChatRecordNames {
                if chat.chatReference?.recordID.recordName == id {

                    followingChats.append(chat)
                    
                }
            }
        }
        
        
//        for id in chatRecordNames {
//            
//            if followingChatRecordNames.contains(id) {
//                
//                for chat in chats {
//                    
//                    if chat.chatReference?.recordID.recordName == id {
//                        followingChats.append(chat)
//                    }
//                }
//            }
//        }
    }
    
    // compare message's creation date timestamp to user's userdefaults last visit to chat.
    
    func newMessagesCheck() {
        
        loadFromUserDefaults()
        
        // then we match the chat name's and check if any of their child messages were created after the last visit.
        
        for chat in chats {
            for chatLog in chatLastVisitLog {
                if chatLog.key == chat.cloudKitRecordID?.recordName {
                    for message in chat.messages {
                        let messageCreationStamp = ChatController.shared.createTimeStamp(theDate: message.timestamp)
                        
                        if messageCreationStamp > chatLog.value {
                            // add message to array of unread
                        }
                        
                        if messageCreationStamp < chatLog.value {
                            // do nothing
                        }
                    }
                }
            }
        }
    }
    
    func loadFromUserDefaults() {
        let userDefaults = UserDefaults.standard
        var chatsVisitLog = [String:String]()
        
        for chat in chats {
            guard let recordName = chat.cloudKitRecordID?.recordName else { return }
            
            let chatsLastVisit = userDefaults.object(forKey: recordName)
            if let date = chatsLastVisit {
                let chatTimestamp = "\(ChatController.shared.createTimeStamp(theDate: date as! Date))"
                chatsVisitLog[recordName] = chatTimestamp
            }
        }
    chatLastVisitLog = chatsVisitLog
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

//MARK: - Sync - maybe put this in the launch vc

func performFullSync(completion: @escaping (() -> Void) = { _ in }) {
    
    //        guard !isSyncing else {
    //            completion()
    //            return
    //        }
    isSyncing = true
    
    pushChangesToCloudKit { (success) in
        self.fetchNewRecordsOf(type: Constants.chattypeKey) {
            self.fetchChatOwnersFor(chats: self.chats, completion: {
                
                self.populateFollowingChats()
                
                self.isSyncing = false
                NotificationCenter.default.post(name: Notification.Name("syncingComplete"), object: nil)
                completion()
            })
            
        }
    }
}

//this is what fetches and sets the chats and messages this should probably go in the launch to happen before the view is loaded

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

// subscribe to chat

func fetchFollowingChats(_ subscriptionID: String, completion: ((_ subscription: CKSubscription?, _ error: Error?) -> Void)?) {
    
    cloudKitManager.publicDatabase.fetch(withSubscriptionID: subscriptionID) { (subscription, error) in
        
        completion?(subscription, error)
    }
    
}

// fetch following chats

func fetchFollowingChatsForUser(user: User, completion: @escaping (_ chats: [Chat]?) -> Void) {
    
    guard let userRecordID = user.cloudKitRecordID else { return }
    
    let predicate = NSPredicate(format: "followingReference == %@", userRecordID)
    
    let query = CKQuery(recordType: Constants.usertypeKey, predicate: predicate)
    
    cloudKitManager.publicDatabase.perform(query, inZoneWith: nil) { (records, error) in
        if let error = error {
            print(error.localizedDescription)
            
        } else {
            guard let records = records else { return }
            
            let chats = records.flatMap({Chat(cloudKitRecord: $0)})
            
            completion(chats)
            
        }
    }
}

func checkSubscriptionTo(chat: Chat, completion: @escaping ((_ subscribed: Bool) -> Void ) = { _ in }) {
    
    guard let subscriptionID = chat.cloudKitRecordID?.recordName else {
        completion(false)
        return
    }
    
    cloudKitManager.fetchSubscription(subscriptionID) { (subscription, error) in
        let subscribed = subscription != nil
        completion(subscribed)
    }
}

func toggleSubscriptionTo(chatNammed chat: Chat,
                          completion: @escaping ((_ success: Bool, _ isSubscribed: Bool, _ error: Error?) -> Void) = { _,_,_ in }) {
    
    guard let subscriptionID = chat.cloudKitRecordID?.recordName else {
        completion(false, false, nil)
        return
    }
    
    cloudKitManager.fetchSubscription(subscriptionID) { (subscription, error) in
        
        if subscription != nil {
            self.removeSubscriptionTo(chat: chat)
            
        } else {
            self.subscribeToChatTopic(chat: chat)
        }
    }
}

func subscribeToChatTopic(chat: Chat) {
    
    let notificationInfo = CKNotificationInfo()
    
    guard let chatID = chat.cloudKitRecordID else { fatalError("Unable to create CloudKit ref for subscription") }
    
    let predicate = NSPredicate(format: "recordID == %@", chatID)
    
    notificationInfo.shouldSendContentAvailable = true
    notificationInfo.shouldBadge = true
    
    let subscription = CKQuerySubscription(recordType: "Chat", predicate: predicate, options: .firesOnRecordUpdate)
    
    subscription.notificationInfo = notificationInfo
    
    cloudKitManager.subscribe(Constants.chattypeKey, predicate: predicate, subscriptionID: chatID.recordName, contentAvailable: true, options: .firesOnRecordCreation) { (_, _) in
        
        print("successfull subscription to chat added")
        
    }
}

// follow messages in a chat subscription

func followMessagesIn(chat: Chat) {
    
    guard let chatID = chat.cloudKitRecordID else { return }
    
    let notificationInfo = CKNotificationInfo()
    
    let messagePredicate = NSPredicate(value: true)
    let chatPredicate = NSPredicate(format: "chatReference == %@", chatID)
    let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [messagePredicate, chatPredicate])
    
    notificationInfo.shouldSendContentAvailable = true
    notificationInfo.shouldBadge = true
    
    // subscribe and stuff
    
    cloudKitManager.subscribe(Constants.messagetypeKey, predicate: predicate, subscriptionID: "ChatMessages", contentAvailable: true, options: .firesOnRecordUpdate) { (_, _) in
        
    }
}

func removeSubscriptionTo(chat: Chat,
                          completion: @escaping ((_ success: Bool, _ error: Error?) -> Void) = { _,_ in }) {
    
    guard let subscriptionID = chat.cloudKitRecordID?.recordName else {
        completion(true, nil)
        return
    }
    
    cloudKitManager.unsubscribe(subscriptionID) { (subscriptionID, error) in
        let success = subscriptionID != nil && error == nil
        completion(success, error)
    }
}
    
    
    //MARK: - Helper Methods 
    
    func createTimeStamp(theDate: Date) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-YYY | hh-mm"
        let strDate = dateFormatter.string(from: theDate)
        return strDate
        
    }

}

/*
 
 christian's subscirption stuff
 
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











