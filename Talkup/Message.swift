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

class Message {
    
    //MARK: - Properties
    
    var owner: String
    var text: String
    var timestamp: Date
    var isRead: Bool
    var score: Int
    var chatReference: CKReference?
    
    
    //MARK: - Inits
    
    init(owner: String, text: String, timestamp: Date = Date(), isRead: Bool = false, score: Int = 0) {

            self.owner = owner
            self.text = text
            self.timestamp = timestamp
            self.isRead = isRead
            self.score = score
    }
    
    //MARK: - CloudKitSyncable 
    
    init?(cloudKitRecord: CKRecord) {
        guard let owner = cloudKitRecord[Constants.usernameKey] as? String,
            let text = cloudKitRecord[Constants.textKey] as? String,
            let timestamp = cloudKitRecord.creationDate,
            let isRead = cloudKitRecord[Constants.hasReadKey] as? Bool,
            let score = cloudKitRecord[Constants.scoreKey] as? Int else { return nil }
        
        self.owner = owner
        self.text = text
        self.timestamp = timestamp
        self.isRead = isRead
        self.score = score 
        self.chatReference = cloudKitRecord[Constants.chatReferenceKey] as? CKReference
    }
}

extension CKRecord {
    convenience init(message: Message) {
        self.init(recordType: "Message")
        self.setValue(message.owner, forKey: Constants.ownerKey)
        self.setValue(message.text, forKey: Constants.textKey)
        self.setValue(message.timestamp, forKey: Constants.timestampKey)
        self.setValue(message.isRead, forKey: Constants.hasReadKey)
        self.setValue(message.score, forKey: Constants.scoreKey)
        
    }
}





