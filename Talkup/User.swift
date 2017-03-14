//
//  User.swift
//  Talkup
//
//  Created by Andrew Ervin Gierke on 3/13/17.
//  Copyright © 2017 Androoo. All rights reserved.
//

import Foundation
import UIKit
import CloudKit

class User: CloudKitSyncable {
  
    //MARK: - Keys
    
    static let typeKey = "User"
    static let photoDataKey = "photoData"
    static let usernameKey = "username"
    
    //MARK: - Properties
    
    let username: String
    let score: Int
    let photoData: Data?
    var profilePic: UIImage? {
        guard let photoData = self.photoData else { return nil }
        return UIImage(data: photoData)
    }
    
    var chats: [Chat]
    
    //MARK: - Init
    
    init(username: String, photoData: Data?, score: Int = 0, chats: [Chat] = []) {
        self.username = username
        self.photoData = photoData
        self.score = score
        self.chats = chats
    }
    
    //MARK: - CloudKitSyncable 
    
    convenience required init?(record: CKRecord) {
        guard let photoAsset = record[User.photoDataKey] as? CKAsset,
            let username = record[User.usernameKey] as? String else { return nil }
        
        let photoData = try? Data(contentsOf: photoAsset.fileURL)
        self.init( username: username, photoData: photoData)
        cloudKitRecordID = record.recordID
    }
    
    fileprivate var temporaryPhotoURL: URL {
        let temporaryDirectory = NSTemporaryDirectory()
        let temporaryDirectoryURL = URL(fileURLWithPath: temporaryDirectory)
        let fileURL = temporaryDirectoryURL.appendingPathComponent(UUID().uuidString).appendingPathExtension("jpg")
        
        try? photoData?.write(to: fileURL, options: [.atomic])
        return fileURL
    }
    
    var recordType: String { return User.typeKey }
    var cloudKitRecordID: CKRecordID?
    
}

//MARK: - CloudKit 

extension CKRecord {
    convenience init(_ user: User) {
        let recordID = CKRecordID(recordName: UUID().uuidString)
        self.init(recordType: user.recordType, recordID: recordID)
        
        self[User.photoDataKey] = CKAsset(fileURL: user.temporaryPhotoURL)
        self[User.usernameKey] = user.username as CKRecordValue?
    }
}
