//
//  LaunchViewController.swift
//  Talkup
//
//  Created by Andrew Ervin Gierke on 3/14/17.
//  Copyright © 2017 Androoo. All rights reserved.
//

import UIKit
import CloudKit

class LaunchViewController: UIViewController {
    
    //MARK: - Properties
    let cloudKitManager = CloudKitManager()
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        get {
            return UIInterfaceOrientationMask.portrait
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        cloudKitManager.fetchCurrentUser { (user) in
            
            DispatchQueue.main.async {
                
                if let currentUser = user {
                    UserController.shared.currentUser = currentUser
                    self.performSegue(withIdentifier: Constants.toChats, sender: self)
                } else {
                    self.performSegue(withIdentifier: Constants.toWelcome, sender: self)
                }
            }
        }
    }
}
