//
//  User.swift
//  Talkup
//
//  Created by Andrew Ervin Gierke on 3/21/17.
//  Copyright © 2017 Androoo. All rights reserved.
//

import Foundation
import CloudKit
import UIKit

class User: CloudKitSyncable {
    
    //MARK: - Properties
    
    var userName: String
    var email: String
    var chats: [Chat]
    var messages: [Message]
    var directMessages: [Message]
    var following: [CKReference]?
    var blocked: [CKReference]?
    var defaultUserReference: CKReference
    var cloudKitRecordID: CKRecordID?
    var users: [User]
    var photoData: Data?
    var photo: UIImage? {
        guard let photoData = self.photoData else { return nil }
        return UIImage(data: photoData)
    }
    var authorized: Bool = false
    var accessCode: String?
    
    
    init(userName: String, email: String, photoData: Data?, chats: [Chat] = [], messages: [Message] = [], directMessages: [Message] = [], following: [CKReference] = [], blocked: [CKReference] = [], users: [User] = [], defaultUserReference: CKReference, authorized: Bool = false, accessCode: String? = nil) {
        self.userName = userName
        self.email = email
        self.photoData = photoData
        self.chats = chats
        self.messages = messages
        self.directMessages = directMessages
        self.following = following
        self.blocked = blocked
        self.users = users
        self.defaultUserReference = defaultUserReference
        self.authorized = authorized
        self.accessCode = accessCode
        
    }
    
    //MARK: - CloudKitSyncable 
    
    convenience required init?(cloudKitRecord: CKRecord) {
        guard let userName = cloudKitRecord[Constants.usernameKey] as? String,
            let email = cloudKitRecord[Constants.userEmailKey] as? String,
            let photoAsset = cloudKitRecord[Constants.photoDataKey] as? CKAsset,
            let authorized = cloudKitRecord[Constants.authorized] as? Bool,
            let accessCode = cloudKitRecord[Constants.accessCode] as? String,
            let defaultUserRef = cloudKitRecord[Constants.userReferenceKey] as? CKReference else {
                return nil
        }
        
        let photoData = try? Data(contentsOf: photoAsset.fileURL)
        self.init(userName: userName, email: email, photoData: photoData, defaultUserReference: defaultUserRef, authorized: authorized, accessCode: accessCode)
        self.following = cloudKitRecord[Constants.followingReferenceKey] as? [CKReference] ?? []
        self.blocked = cloudKitRecord[Constants.blockedReferenceKey] as? [CKReference] ?? []
        self.defaultUserReference = defaultUserRef
        self.cloudKitRecordID = cloudKitRecord.recordID
            
    }
    
    fileprivate var temporaryPhotoURL: URL {
        let temporaryDirectory = NSTemporaryDirectory()
        let temporaryDirectoryURL = URL(fileURLWithPath: temporaryDirectory)
        let fileURL = temporaryDirectoryURL.appendingPathComponent(UUID().uuidString).appendingPathExtension("jpg")
        
        try? photoData?.write(to: fileURL, options: [.atomic])
        
        return fileURL
    }
    
    var recordType: String { return Constants.usertypeKey }

}

extension CKRecord {
    convenience init(user: User) {
        
        let recordID = user.cloudKitRecordID ?? CKRecordID(recordName: UUID().uuidString)
        self.init(recordType: user.recordType, recordID: recordID)
        
        self[Constants.usernameKey] = user.userName as CKRecordValue?
        self[Constants.userEmailKey] = user.email as CKRecordValue?
        self[Constants.authorized] = user.authorized as CKRecordValue?
        self[Constants.accessCode] = user.accessCode as CKRecordValue?
        self[Constants.photoDataKey] = CKAsset(fileURL: user.temporaryPhotoURL)
//        self[Constants.blockedReferenceKey] = user.blocked as CKRecordValue?
        self[Constants.userReferenceKey] = user.defaultUserReference
        
        guard let blocked = user.blocked,
            let following = user.following else { return }
        
        self.setValue(following, forKey: Constants.followingReferenceKey)
        self.setValue(blocked, forKey: Constants.blockedReferenceKey)
    }
}
















