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

class ChatController {
    
    //MARK: - Properties 
    
    static let cloudKitManager = CloudKitManager()
    static let shared = ChatController()
    
    static let chatsDidChangeNotification = Notification.Name("chatsDidChange")
    
    var isSyncing: Bool = false
    
    static var chats: [Chat] = [] {
        didSet {
            NotificationCenter.default.post(name: chatsDidChangeNotification, object: self)
        }
    }
    
    static func createChatWithName(name: String) -> Chat {
        return Chat(topic: name)
    }
    
    static func createMessageWithText(owner: String, text: String) -> Message {
        return Message(owner: owner, text: text)
    }
    
    //MARK: - CRUD Methods 
    
    static func addChatToCloudKit(chatTopic: String, owner: String, firstMessage: String, completion: @escaping () -> Void) {
        
        let chat = createChatWithName(name: chatTopic)
        let message = createMessageWithText(owner: owner, text: firstMessage)
        
        if chat.messages != nil {
            chat.messages!.append(message)
        } else {
            chat.messages = [message]
        }
        
        let chatRecord = CKRecord(chat: chat)
        
        chat.cloudKitRecordID = chatRecord.recordID
        
        cloudKitManager.saveRecord(chatRecord) { (record, error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                guard let chatRecordID = chat.cloudKitRecordID,
                    let messages = chat.messages else { return }
                for message in messages {
                    message.chatReference = CKReference(recordID: chatRecordID, action: .deleteSelf)
                }
                let messageRecords = messages.flatMap({CKRecord(message: $0)})
                let modifyOperation = CKModifyRecordsOperation(recordsToSave: messageRecords, recordIDsToDelete: nil)
                
                modifyOperation.completionBlock = {
                    self.chats.append(chat)
                    completion()
                }
                modifyOperation.savePolicy = .changedKeys
                cloudKitManager.publicDatabase.add(modifyOperation)
            }
        }
    }
    
    static func fetchAllChats(completion: @escaping () -> Void) {
        
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "Chat", predicate: predicate)
        
        cloudKitManager.publicDatabase.perform(query, inZoneWith: nil) { (records, error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                guard let records = records else { return }
                let chats = records.flatMap({Chat(cloudKitRecord: $0)})
                self.chats = chats
                completion()
            }
        }
    }
}

















