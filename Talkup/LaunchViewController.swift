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
    
    
    //MARK: - Check if user is user is registered
    
    //MARK: - TODO - check that use userID is associated with a username and email
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        cloudKitManager.fetchLoggedInUserRecord { (recordID, error) in
            guard let userID = recordID,
                let email = recordID?[Constants.userEmailKey],
                let username = recordID?[Constants.usernameKey] else {
                    
                    NSLog("Fetched iCloudID was nil")
                    self.pushTo(viewController: .welcome)
                    return
                    
            }
            
            NSLog("recieved iCLoudID \(userID)")
            self.pushTo(viewController: .conversations)
            
        }
    }
    
    
    
    
    //MARK: - Push to relevant ViewController
    
    func pushTo(viewController: ViewControllerType) {
        switch viewController {
        case .conversations:
            guard let vc = storyboard?.instantiateViewController(withIdentifier: "Navigation") as? NavViewController else { return }
            self.present(vc, animated: false, completion: nil)
        case .welcome:
            guard let vc = storyboard?.instantiateViewController(withIdentifier: "Welcome") as? WelcomeViewController else { return }
            self.present(vc, animated: false, completion: nil)
        }
    }
}
