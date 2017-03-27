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
    
    var owner: User?
    var ownerReference: CKReference
    var text: String
    var timestamp: Date
    var isRead: Bool
    var score: Int
    var chat: Chat?
    
    var cloudKitRecordID: CKRecordID?
    
    //MARK: - Inits
    
    init(owner: User? = nil, ownerReference: CKReference, text: String, timestamp: Date = Date(), isRead: Bool = false, score: Int = 0, chat: Chat?) {
        
        self.owner = owner
        self.ownerReference = ownerReference
        self.text = text
        self.timestamp = timestamp
        self.isRead = isRead
        self.score = score
        self.chat = chat
       
    }
    
    //MARK: - CloudKitSyncable
    
    convenience required init?(cloudKitRecord: CKRecord) {
        guard let ownerReference = cloudKitRecord[Constants.ownerKey] as? CKReference,
            let text = cloudKitRecord[Constants.textKey] as? String,
            let timestamp = cloudKitRecord.creationDate,
            let isRead = cloudKitRecord[Constants.hasReadKey] as? Bool,
            let score = cloudKitRecord[Constants.scoreKey] as? Int else {
                return nil
        }
        
        self.init(ownerReference: ownerReference, text: text, timestamp: timestamp, isRead: isRead, score: score, chat: nil)
        
        self.cloudKitRecordID = cloudKitRecord.recordID
    }
//    var creatorUserRecordID: CKRecordID?

    var recordType: String { return Constants.messagetypeKey }
}

extension CKRecord {
    convenience init(message: Message) {
        
        guard let chat = message.chat else { fatalError("Message does not have a Chat relationship") }
        
        let ownerRecordID = message.ownerReference.recordID
        let chatRecordID = chat.cloudKitRecordID ?? CKRecord(chat: chat).recordID
        let recordID = message.cloudKitRecordID ?? CKRecordID(recordName: UUID().uuidString)
        
        self.init(recordType: message.recordType, recordID: recordID)
        
        self[Constants.ownerKey] = CKReference(recordID: ownerRecordID, action: .deleteSelf)
        self[Constants.textKey] = message.text as CKRecordValue?
        self[Constants.timestampKey] = message.timestamp as CKRecordValue?
        self[Constants.hasReadKey] = message.isRead as CKRecordValue?
        self[Constants.scoreKey] = message.score as CKRecordValue?
        self[Constants.chatKey] = CKReference(recordID: chatRecordID, action: .deleteSelf)
    }
}





