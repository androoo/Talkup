//
//  UserController.swift
//  Talkup
//
//  Created by Andrew Ervin Gierke on 3/13/17.
//  Copyright © 2017 Androoo. All rights reserved.
//

import Foundation
import CloudKit
import UIKit

class UserController {
    
    //MARK: - Properties 
    
    static let shared = UserController()
    let cloudKitManager: CloudKitManager
    var isSyncing: Bool = false
    
    var users = [User]() {
        didSet {
            //dispatch to main 
                //notification center
        }
    }
    
    //MARK: - Inits
    
    init() {
        self.cloudKitManager = CloudKitManager()
        //performFullSync() 
        //subscribeToNewPosts { }
    }
    
    //MARK: - Methods 
    
    func registerNewUser(userName: String, completion: ((User) -> Void)?) {
        
        //need to cast as CKRecord in User class or wont work
        let user = User(username: userName, photoData: nil)
        
        cloudKitManager.saveRecord(CKRecord(user)) { (record, error) in
            guard let record = record else {
                if let error = error {
                    NSLog("Error registering new user with CloudKit: \(error)")
                    return
                }
                let userInfo = ["username": userName]
                UserDefaults.standard.set(userInfo, forKey: "userInformation")
                
                completion?(user)
                return
            }
            user.cloudKitRecordID = record.recordID
        }
    }
    
    

    //loginuser 
    
    
    
}
