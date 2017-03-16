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

    //MARK: - Properties
    var topic: String
    var score: Int?
    var messages: [Message]
    
    //MARK: - CloudKitSyncable
    
    init(topic: String, score: Int? = 0, messages: [Message] = []) {
        self.topic = topic
        self.score = score
        self.messages = messages
    }
    
    convenience required init?(cloudKitRecord: CKRecord) {
        guard let topic = cloudKitRecord[Constants.chatKey] as? String /*,
            let messages = cloudKitRecord[Constants.messagesKey] as? [Message] */ else { return nil }

        self.init(topic: topic, messages: [])
//        self.init(topic: topic, messages: messages)
        self.cloudKitRecordID = cloudKitRecord.recordID
    }
    
    var recordType: String { return Constants.chatTopicKey }
    var cloudKitRecordID: CKRecordID?
}

//MARK: -

extension CKRecord {
    convenience init(chat: Chat) {
        let recordID = CKRecordID(recordName: UUID().uuidString)
        self.init(recordType: Constants.chattypeKey, recordID: recordID)
        
        self.setValue(chat.topic, forKey: Constants.chatKey)
    }
}

