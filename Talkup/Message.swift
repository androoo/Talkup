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
    
    var owner: MessageOwner = .receiver
    var type: MessageType
    var timestamp: Date
    var isRead: Bool
    var image: UIImage?
    var score: Int
    let content: Any
    var chat: Chat
    private var toChatID: String?
    private var fromID: String?
    
    //MARK: - Inits
    
    init(type: MessageType = .text, owner: MessageOwner = .receiver, chat: Chat, timestamp: Date = Date(), isRead: Bool = false, content: Any, score: Int = 0) {
            self.type = type
            self.owner = owner
            self.chat = chat
            self.timestamp = timestamp
            self.isRead = isRead
            self.content = content
            self.score = score
    }
    
    //MARK: - CloudKitSyncable 
    
    convenience required init?(record: CKRecord) {
        guard let timestamp = record.creationDate else { return nil }
        
        self.init(chat: chat, timestamp: timestamp, content: content)
            cloudKitRecordID = record.recordID
    }
    var cloudKitRecordID: CKRecordID?
    var recordType: String { return Message.typeKey }
}

extension CKRecord {
    convenience init(_ message: Message) {
        let chat = message.chat
        let chatRecordID = chat.cloudKitRecordID ?? CKRecord(chat).recordID
        let recordID = CKRecordID(recordName: UUID().uuidString)
        
        self.init(recordType: message.recordType, recordID: recordID)
        
        self[Message.timestampKey] = message.timestamp as CKRecordValue?
        self[Message.chatKey] = CKReference(recordID: chatRecordID, action: .deleteSelf)
        
    }
}





