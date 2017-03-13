//
//  Chat.swift
//  Talkup
//
//  Created by Andrew Ervin Gierke on 3/13/17.
//  Copyright © 2017 Androoo. All rights reserved.
//

import Foundation
import UIKit
import CloudKit

class Chat: CloudKitSyncable {
    
    //MARK: - Keys 
    
    static let typeKey = "Chat"
    static let topicKey = "topic"
    static let usersKey = "users"
    static let messagesKey = "messages"
    
    //MARK: - Properties
    let topic: String
    let users: [User]
    let score: Int
    var messages: [Message]
    
    //MARK: - Inits
    
    init(topic: String, users: [User], score: Int = 0, messages: [Message]) {
        self.topic = topic
        self.users = users
        self.score = score
        self.messages = messages
    }
    //turn into asset if giving to ck
    
    convenience required init?(record: CKRecord) {
        guard let topic = record[Chat.topicKey] as? CKAsset,
            let users = record[Chat.usersKey] as? CKAsset,
            let messages = record[Chat.messagesKey] as? CKAsset else { return nil }
        
        self.init(topic: topic, users: users, messages: messages)
        cloudKitRecordID = record.recordID
    }
    
    var recordType: String { return Chat.typeKey }
    var cloudKitRecordID: CKRecordID?
}

//MARK: - CloudKit 

extension CKRecord {
    convenience init(_ chat: Chat) {
        let recordID = CKRecordID(recordName: UUID().uuidString)
        self.init(recordType: chat.recordType, recordID: recordID)
        self[Chat.topicKey] = chat.topic as CKRecordValue?
    }
}
