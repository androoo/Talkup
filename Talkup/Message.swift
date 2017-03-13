//
//  Message.swift
//  Talkup
//
//  Created by Andrew Ervin Gierke on 3/13/17.
//  Copyright © 2017 Androoo. All rights reserved.
//

import Foundation
import CloudKit
import UIKit

class Message: CloudKitSyncable {
    
    //MARK: - Keys
    
    static let typeKey = "Message"
    static let ownerKey = "owner"
    static let chatKey = "chat"
    static let timestampKey = "timestamp"
    
    //MARK: - Properties
    
    var owner: MessageOwner
    var type: MessageType
    var content: Any
    var timestamp: Int
    var isRead: Bool
    var image: UIImage?
    var score: Int
    var chat: Chat
    private var toChatID: String?
    private var fromID: String?
    
    //MARK: - Inits
    
    init(type: MessageType, content: Any, owner: MessageOwner, chat: Chat, timestamp: Int, isRead: Bool, score: Int = 0) {
            self.type = type
            self.content = content
            self.owner = owner
            self.chat = chat
            self.timestamp = timestamp
            self.isRead = isRead
    }
    
    //MARK: - CloudKitSyncable 
    
    convenience required init?(record: CKRecord) {
        
        guard let timestamp = record.creationDate,
            let text = record[Message.typeKey] as? String else { return nil }
        
        self.init(type: MessageType, content: Any, owner: MessageOwner, chat: Chat, timestamp: timestamp, isRead: Bool)
            cloudKitRecordID = record.recordID
    }
    var cloudKitRecordID: CKRecordID?
    var recordType: String { return Message.typeKey }
}

extension CKRecord {
    convenience init(_ message: Message) {
        guard let chat = message.chat else { fatalError("Message does not have a parent chat") }
        let userRecordID = chat.cloudKitRecordID ?? CKRecord(chat).recordID
        let recordID = CKRecordID(recordName: UUID().uuidString)
        
        self.init(recordType: message.recordType, recordID: recordID)
        
        self[Message.timestampKey] = message.timestamp as CKRecordValue?
        self[Message.ownerKey] = message.owner as CKRecordValue?
        self[Message.chatKey] = CKReference(recordID: )
        
    }
}





