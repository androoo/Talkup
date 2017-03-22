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
    
    let cloudKitManager: CloudKitManager
    
    init() {
        self.cloudKitManager = CloudKitManager()
    }
    
    //MARK: - CloudKit Helpers
    
    func createUserWith(username: String, email: String, image: UIImage, completion: ((User) -> Void)?) {
        
        guard let data = UIImageJPEGRepresentation(image, 0.8) else { return }
        
        let user = User(userName: username, email: email, photoData: data)
        
        cloudKitManager.saveRecord(CKRecord(user: user)) { (record, error) in
            guard let record = record else {
            
                if let error = error {
                    NSLog("Error saving new user: \(error)")
                    return
                }
            
                completion?(user)
                return
            }
            user.cloudKitRecordID = record.recordID
        }
        
    }
    
    
    
    
    
    // blockUserWith
    
    
    
}
