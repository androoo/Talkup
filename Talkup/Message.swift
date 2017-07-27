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
    var blocked: Bool
    var score: Int
    var chat: Chat?
    var chatReference: CKReference
    
    var cloudKitRecordID: CKRecordID?
    
    //MARK: - Inits
    
    init(owner: User? = nil, ownerReference: CKReference, text: String, timestamp: Date = Date(), blocked: Bool = false, score: Int = 1, chat: Chat? = nil, chatReference: CKReference) {
        
        self.owner = owner
        self.ownerReference = ownerReference
        self.text = text
        self.timestamp = timestamp
        self.blocked = blocked
        self.score = score
        self.chat = chat
        self.chatReference = chatReference
        
    }
    
    //MARK: - Date Helper
    
    func timeSinceCreation(from: Date, to: Date) -> String {
        
        let date = timestamp
        let calendar = NSCalendar.current
        
        let day = calendar.component(.day, from: date)
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        let seconds = calendar.component(.second, from: date)
        
        
        if hour >= 24 {
            return "\(day)d"
        } else if hour >= 0 && minutes >= 0 && seconds >= 0 {
            return "\(hour)h"
        } else if hour <= 0 && minutes >= 0 && seconds >= 0 {
            return "\(minutes)m"
        } else {
            return "\(seconds)s"
        
        }
    }
    
    //MARK: - CloudKitSyncable
    
    convenience required init?(cloudKitRecord: CKRecord) {
        guard let ownerReference = cloudKitRecord[Constants.ownerKey] as? CKReference,
            let text = cloudKitRecord[Constants.textKey] as? String,
            let timestamp = cloudKitRecord.creationDate,
            let blocked = cloudKitRecord[Constants.blockedKey] as? Bool,
            let score = cloudKitRecord[Constants.scoreKey] as? Int,
            let chatReference = cloudKitRecord[Constants.chatKey] as? CKReference else {
                return nil
        }
        
        self.init(ownerReference: ownerReference, text: text, timestamp: timestamp, blocked: blocked, score: score, chatReference: chatReference)
        
        self.cloudKitRecordID = cloudKitRecord.recordID
    }
    //    var creatorUserRecordID: CKRecordID?
    
    var recordType: String { return Constants.messagetypeKey }
}

//MARK: - Extenstions 

extension Message: SearchableRecord {
    func matches(searchTerm: String) -> Bool {
        return text.contains(searchTerm)
    }
}

extension CKRecord {
    convenience init(message: Message) {
        
        let ownerRecordID = message.ownerReference.recordID
        let chatRecordID = message.chatReference.recordID
        let recordID = message.cloudKitRecordID ?? CKRecordID(recordName: UUID().uuidString)
        
        self.init(recordType: message.recordType, recordID: recordID)
        
        self[Constants.ownerKey] = CKReference(recordID: ownerRecordID, action: .deleteSelf)
        self[Constants.textKey] = message.text as CKRecordValue?
        self[Constants.timestampKey] = message.timestamp as CKRecordValue?
        self[Constants.blockedKey] = message.blocked as CKRecordValue?
        self[Constants.scoreKey] = message.score as CKRecordValue?
        
        self[Constants.chatKey] = CKReference(recordID: chatRecordID, action: .deleteSelf)
        
    }
}





