//
//  MessageController.swift
//  Talkup
//
//  Created by Andrew Ervin Gierke on 3/13/17.
//  Copyright © 2017 Androoo. All rights reserved.
//

import Foundation
import CloudKit

protocol voteButtonTapped {
    func updateMessageScore()
}

class MessageController {
    
    static let shared = MessageController()
    static let cloudKitManager = CloudKitManager()
    
    var isSyncing: Bool = false
    
    var messages = [Message]() {
        didSet {
            DispatchQueue.main.async {
                
            }
        }
    }
    
    init() {
        performFullSync()
    }
    
    //download and sync all messages 
    
    //upload new message
    
    //mark messages as read
    
    func performFullSync(completion: @escaping (() -> Void) = { _ in }) {
        guard !isSyncing else {
            completion()
            return
        }
        isSyncing = true
    }
    
    static func fetchMessagesFor(chat: Chat, completion: @escaping () -> Void) {
        
        guard let chatRecordID = chat.cloudKitRecordID else { return }
        let predicate = NSPredicate(format: "chatReference == %@", chatRecordID)
        let query = CKQuery(recordType: "Message", predicate: predicate)
        
        cloudKitManager.publicDatabase.perform(query, inZoneWith: nil) { (records, error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                guard let records = records else { return }
                
                let messages = records.flatMap({Message(cloudKitRecord: $0)})
                chat.messages = messages
                completion()
            }
        }
        
    }
}
