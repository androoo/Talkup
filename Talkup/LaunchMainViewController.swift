//
//  LaunchMainViewController.swift
//  Talkup
//
//  Created by Andrew Ervin Gierke on 8/24/17.
//  Copyright © 2017 Androoo. All rights reserved.
//

import UIKit

class LaunchMainViewController: UIViewController {
    
    //MARK: - Properties
    
    let cloudKitManager = CloudKitManager()
    var user: User?
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        get {
            return UIInterfaceOrientationMask.portrait
        }
    }

    //MARK: - View Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        cloudKitManager.fetchCurrentUser { (user) in
            
            DispatchQueue.main.async {
                
                if let currentUser = user {
                    UserController.shared.currentUser = currentUser
                    
                    ChatController.shared.performFullSync(completion: {
                        self.performSegue(withIdentifier: "loadmain", sender: self)
                    })
                    
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
    }
}
