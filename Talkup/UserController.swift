//
//  UserController.swift
//  Talkup
//
//  Created by Andrew Ervin Gierke on 3/21/17.
//  Copyright © 2017 Androoo. All rights reserved.
//

import Foundation
import CloudKit
import UIKit

class UserController {
    
    //MARK: - Properties
    
    static let shared = UserController()
    
    let cloudKitManager = CloudKitManager()
    
    let currentUserWasSetNotification = Notification.Name("currentUserWasSet")
    
    var defaultUserRecordID: CKRecordID?
    
    var currentUser: User? {
        didSet {
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: self.currentUserWasSetNotification, object: self)
            }
            // fetch current user's chat
        }
    }
    
    var currentUserDirectChat: Chat? {
        didSet {
            
        }
    }
    
    var allUsernames: [String]?
    
    //MARK: - View lifecycle
    
    init() {
        CKContainer.default().fetchUserRecordID { (recordID, error) in
            guard let recordID = recordID else { return }
            self.defaultUserRecordID = recordID
        }
    }
    
    //MARK: - CloudKit Helpers
    
    func createUserWith(username: String, email: String, image: UIImage, accessCode: String, completion: @escaping (User?) -> Void) {
        
        guard let data = UIImageJPEGRepresentation(image, 0.8) else { return }
        
        guard let defaultUserRecordID = defaultUserRecordID else { completion(nil); return }
        
        let defaultUserRef = CKReference(recordID: defaultUserRecordID, action: .deleteSelf)
        
        _ = User(userName: username, email: email, photoData: data, defaultUserReference: defaultUserRef)
        
        let uuser = User(userName: username, email: email, photoData: data, defaultUserReference: defaultUserRef, accessCode: accessCode)
        
        let userRecord = CKRecord(user: uuser)
        
        CKContainer.default().publicCloudDatabase.save(userRecord) { (record, error) in
            
            if let error = error { print(error.localizedDescription) }
            
            guard let record = record,
                let currentUser = User(cloudKitRecord: record) else { completion(nil); return }
            
            self.currentUser = currentUser
            completion(currentUser)
        }
        
    }
    
    // Add blocked users
    
    func addBlockedUser(Foruser user: User, blockedUser: User, completion: @escaping () -> Void = {_ in}) {
        
        guard let userID = user.cloudKitRecordID,
            let blockedUser = blockedUser.cloudKitRecordID else { return }
        
        cloudKitManager.fetchRecord(withID: userID) { (record, error) in
            if let error = error {
                print("\(error)")
                completion()
            } else if let record = record {
                
                let reference = CKReference(recordID: blockedUser, action: .none)                

                if user.blocked == nil {
                    user.blocked = [reference]
                } else {
                    user.blocked?.append(reference)
                }
                
                guard let blockedUserReferences = user.blocked else { return }
                record.setValue(blockedUserReferences, forKey: Constants.blockedReferenceKey)
                self.cloudKitManager.saveRecord(record, completion: { (record, error) in
                    if let error = error {
                        print("\(error)")
                        completion()
                    } else {
                        print("saving blocked users success")
                        completion()
                    }
                })
            }
        }
    }
    
    // Follow Chat
    
    func followChat(Foruser user: User, chat: Chat, completion: @escaping () -> Void = {_ in}) {
        
        guard let userID = user.cloudKitRecordID,
            let chat = chat.cloudKitRecordID else { return }
        
        cloudKitManager.fetchRecord(withID: userID) { (record, error) in
            if let error = error {
                print("\(error)")
                completion()
                
            } else if let record = record {
                
                let reference = CKReference(recordID: chat, action: .none)
                
                if user.following == nil {
                    user.following = [reference]
                } else {
                    user.following?.append(reference)
                }
                
                guard let followingChatReferences = user.following else { return }
                record.setValue(followingChatReferences, forKey: Constants.followingReferenceKey)
                self.cloudKitManager.saveRecord(record, completion: { (record, error) in
                    if let error = error {
                        print("\(error)")
                        completion()
                    } else {
                        print("following chat succes")
                        completion()
                    }
                })
            }
        }
    }

    //MARK: - Fetches
    
    // Fetch all usernames for sign up 
    
    
    func fetchAllUsernames(completion: @escaping() -> Void) {
        
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: Constants.usertypeKey, predicate: predicate)
        
        let operation = CKQueryOperation(query: query)
        operation.desiredKeys = ["username"]
        
        var usernames = [String]()
        
        operation.queryCompletionBlock = ( { (cursor, error) -> Void in
            
            if let error = error {
                print(error.localizedDescription)
            }
        
            DispatchQueue.main.async {
                // do something with results 
                print(cursor)
            }
            
        })
        
        operation.recordFetchedBlock = ( { (record) -> Void in
        
            guard let username = record.value(forKey: "username") as? String else { return }
            usernames.append(username)
            self.allUsernames = usernames
            
        })
        
        cloudKitManager.publicDatabase.add(operation)
        
        cloudKitManager.publicDatabase.perform(query, inZoneWith: nil) { (records, error) in
            // handle error
            // take results and add each username to array
        }
        
    }
    
    
    //Fetch Messages by User
    
    func fetchMessagesBy(user: User, completion: @escaping () -> Void) {
        
        guard let userRecordID = user.cloudKitRecordID else { return }
        
        let predicate = NSPredicate(format: "creator == %@", userRecordID)
        
        let query = CKQuery(recordType: Constants.chattypeKey, predicate: predicate)
        
        cloudKitManager.publicDatabase.perform(query, inZoneWith: nil) { (records, error) in
            
            if let error = error {
                print(error.localizedDescription)
            } else {
                guard let records = records else { return }
                
                let chats = records.flatMap({Chat(cloudKitRecord: $0)})
                
                user.chats = chats
                completion()
            }
        }
    }
    
    @discardableResult func addMessage(byUser owner: User, toChat chat: Chat, messageText: String, completion: @escaping ((Message) -> Void) = { _ in }) -> Message {
        
        let ownerReference = owner.cloudKitReference
        let chatReference = chat.cloudKitReference
        
        let message = Message(ownerReference: ownerReference!, text: messageText, chatReference: chatReference!)
        chat.messages.append(message)
        
        cloudKitManager.saveRecord(CKRecord(message: message)) { (record, error) in
            if let error = error {
                NSLog("Error saving new comment to CloudKit: \(error)")
                return
            }
            message.cloudKitRecordID = record?.recordID
            
            DispatchQueue.main.async {
                let nc = NotificationCenter.default
                nc.post(name: ChatController.ChatMessagesChangedNotification, object: chat)
            }
            
            message.owner = owner
            
            completion(message)
        }
        return message
    }
}
