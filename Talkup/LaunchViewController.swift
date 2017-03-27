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
            UserController.shared.currentUser = user
            
            if user == nil {
                NSLog("current user fetch was nil")
                self.pushTo(viewController: .welcome)
            } else {
                NSLog("got a user")
                self.pushTo(viewController: .conversations)
            }
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
