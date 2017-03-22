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
    
    let userName: String
    let email: String
    
    let photoData: Data?
    var photo: UIImage? {
        guard let photoData = self.photoData else { return nil }
        return UIImage(data: photoData)
    }
    
    var chats: [Chat]
    var messages: [Message]
    var blocked: [User]
    
    init(userName: String, email: String, photoData: Data?, chats: [Chat] = [], messages: [Message] = [], blocked: [User] = []) {
        self.userName = userName
        self.email = email
        self.photoData = photoData
        self.chats = chats
        self.messages = messages
        self.blocked = blocked
    }
    
    //MARK: - CloudKitSyncable 
    
    convenience required init?(cloudKitRecord: CKRecord) {
        guard let userName = cloudKitRecord[Constants.usernameKey] as? String,
            let email = cloudKitRecord[Constants.userEmailKey] as? String,
            let photoAsset = cloudKitRecord[Constants.photoDataKey] as? CKAsset else { return nil }
        
        let photoData = try? Data(contentsOf: photoAsset.fileURL)
        self.init(userName: userName, email: email, photoData: photoData)
        cloudKitRecordID = cloudKitRecord.recordID
            
    }
    
    fileprivate var temporaryPhotoURL: URL {
        let temporaryDirectory = NSTemporaryDirectory()
        let temporaryDirectoryURL = URL(fileURLWithPath: temporaryDirectory)
        let fileURL = temporaryDirectoryURL.appendingPathComponent(UUID().uuidString).appendingPathExtension("jpg")
        
        try? photoData?.write(to: fileURL, options: [.atomic])
        
        return fileURL
    }
    
    var recordType: String { return Constants.usertypeKey }
    var cloudKitRecordID: CKRecordID?

}

extension CKRecord {
    convenience init(user: User) {
        let recordID = CKRecordID(recordName: UUID().uuidString)
        self.init(recordType: user.recordType, recordID: recordID)
        //might be something messed up here TODO bitch
        self[Constants.usernameKey] = user.userName as CKRecordValue?
        self[Constants.userEmailKey] = user.email as CKRecordValue?
        self[Constants.photoDataKey] = CKAsset(fileURL: user.temporaryPhotoURL)
    }
}
















