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
    
    var isSyncing: Bool = false
    
    static var chats: [Chat] = []
    
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
        
        chat.messages.append(message)
        
        let chatRecord = CKRecord(chat: chat)
        
        chat.cloudKitRecordID = chatRecord.recordID
        
        cloudKitManager.saveRecord(chatRecord) { (record, error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                guard let chatRecordID = chat.cloudKitRecordID else { return }
                for message in chat.messages {
                    message.chatReference = CKReference(recordID: chatRecordID, action: .deleteSelf)
                }
                let messageRecords = chat.messages.flatMap({CKRecord(message: $0)})
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
}

















