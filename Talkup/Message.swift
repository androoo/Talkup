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
    
    //MARK: - Properties
    
    var owner: String
    var text: String
    var timestamp: Date
    var isRead: Bool
    var score: Int
    var chat: Chat?
    
    //MARK: - Inits
    
    init(owner: String, text: String, timestamp: Date = Date(), isRead: Bool = false, score: Int = 0, chat: Chat?) {
        
        self.owner = owner
        self.text = text
        self.timestamp = timestamp
        self.isRead = isRead
        self.score = score
        self.chat = chat
    }
    
    //MARK: - CloudKitSyncable
    
    convenience required init?(cloudKitRecord: CKRecord) {
        guard let owner = cloudKitRecord[Constants.ownerKey] as? String,
            let text = cloudKitRecord[Constants.textKey] as? String,
            let timestamp = cloudKitRecord.creationDate,
            let isRead = cloudKitRecord[Constants.hasReadKey] as? Bool,
            let score = cloudKitRecord[Constants.scoreKey] as? Int else { return nil }
        
        self.init(owner: owner, text: text, timestamp: timestamp, isRead: isRead, score: score, chat: nil)
    }
//    var creatorUserRecordID: CKRecordID?
    
    var cloudKitRecordID: CKRecordID?
    var recordType: String { return Constants.messagetypeKey }
}

extension CKRecord {
    convenience init(message: Message) {
        
        guard let chat = message.chat else { fatalError("Message does not have a Chat relationship") }
        
        let chatRecordID = chat.cloudKitRecordID ?? CKRecord(chat: chat).recordID
        let recordID = CKRecordID(recordName: UUID().uuidString)
        
        self.init(recordType: message.recordType, recordID: recordID)
        
        self[Constants.ownerKey] = message.owner as CKRecordValue?
        self[Constants.textKey] = message.text as CKRecordValue?
        self[Constants.timestampKey] = message.timestamp as CKRecordValue?
        self[Constants.hasReadKey] = message.isRead as CKRecordValue?
        self[Constants.scoreKey] = message.score as CKRecordValue?
        self[Constants.chatKey] = CKReference(recordID: chatRecordID, action: .deleteSelf)
        
    }
}





