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
    
    static let shared = UserController()
    
    var defaultUserRecordID: CKRecordID?
    
    let currentUserWasSetNotification = Notification.Name("currentUserWasSet")
    
    var currentUser: User? {
        didSet {
            NotificationCenter.default.post(name: currentUserWasSetNotification, object: nil)
        }
    }
    
    let cloudKitManager: CloudKitManager
    
    init() {
        self.cloudKitManager = CloudKitManager()
        
        CKContainer.default().fetchUserRecordID { (recordID, error) in
            guard let recordID = recordID else { return }
            
            self.defaultUserRecordID = recordID
        }
        
        cloudKitManager.fetchCurrentUser { (currentUser) in
            self.currentUser = currentUser
        }
        
    }
    
    //MARK: - CloudKit Helpers
    
    func createUserWith(username: String, email: String, image: UIImage, completion: @escaping (User?) -> Void) {
        
        guard let data = UIImageJPEGRepresentation(image, 0.8) else { return }
        
        guard let defaultUserRecordID = defaultUserRecordID else { completion(nil); return }
        
        let defaultUserRef = CKReference(recordID: defaultUserRecordID, action: .deleteSelf)
        
        let user = User(userName: username, email: email, photoData: data, defaultUserReference: defaultUserRef)
        
        let userRecord = CKRecord(user: user)

        CKContainer.default().publicCloudDatabase.save(userRecord) { (record, error) in
            if let error = error { print(error.localizedDescription) }
            
            guard let record = record,
                let currentUser = User(cloudKitRecord: record) else { completion(nil); return }
            
            self.currentUser = currentUser
            completion(currentUser)
        }
        
    }
    
    // check if user info already exists
    
    
    
    // blockUserWith
    
    
    
}
