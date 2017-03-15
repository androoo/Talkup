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

class Chat {

    //MARK: - Properties
    var topic: String
    var score: Int?
    var messages: [Message]?
    var cloudKitRecordID: CKRecordID?
    
    //MARK: - Inits
    
    init(topic: String, score: Int? = 0, messages: [Message]? = nil) {
        self.topic = topic
        self.score = score
        self.messages = messages
    }
    
    init?(cloudKitRecord: CKRecord) {
        guard let topic = cloudKitRecord[Constants.chatKey] as? String else { return nil }
        
        self.topic = topic
        self.cloudKitRecordID = cloudKitRecord.recordID
    }
}

//MARK: - CloudKit 

extension CKRecord {
    convenience init(chat: Chat) {
        self.init(recordType: "Chat")
        self.setValue(chat.topic, forKey: Constants.chatKey)
    }
}
