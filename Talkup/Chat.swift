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
    
    var creator: User?
    var creatorReference: CKReference
    var topic: String
    var score: Int?
    var messages: [Message]
    
    var filteredMessages: [Message] {
        return messages.filter({$0.blocked == false})
    }
    
    var cloudKitRecordID: CKRecordID?
    
    var chatReference: CKReference? {
        guard let cloudKitRecordID = cloudKitRecordID else { return nil }
        return CKReference(recordID: cloudKitRecordID, action: .deleteSelf)
    }
    
    //MARK: - CloudKitSyncable
    
    init(creator: User? = nil, creatorReference: CKReference, topic: String, score: Int? = 0, messages: [Message] = []) {
        self.creator = creator
        self.creatorReference = creatorReference
        self.topic = topic
        self.score = score
        self.messages = messages
    }
    
    required init?(cloudKitRecord: CKRecord) {
        guard let creatorReference = cloudKitRecord[Constants.chatCreatorKey] as? CKReference,
            let topic = cloudKitRecord[Constants.chatKey] as? String else { return nil }

        self.creatorReference = creatorReference
        self.topic = topic
        self.cloudKitRecordID = cloudKitRecord.recordID
        self.messages = []
    }
    
    var recordType: String { return Constants.chattypeKey }
}

//MARK: - extensions 

extension Chat: SearchableRecord {
    func matches(searchTerm: String) -> Bool {
        return self.topic.lowercased().contains(searchTerm)
    }
}

extension CKRecord {
    convenience init(chat: Chat) {
        let recordID = CKRecordID(recordName: UUID().uuidString)
        self.init(recordType: chat.recordType, recordID: recordID)
        
        self[Constants.chatKey] = chat.topic as CKRecordValue?
        self[Constants.chatReferenceKey] = chat.chatReference
        self[Constants.chatCreatorKey] = chat.creatorReference
    }
}

