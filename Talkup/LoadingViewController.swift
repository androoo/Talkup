//
//  LoadingViewController.swift
//  Talkup
//
//  Created by Andrew Ervin Gierke on 3/14/17.
//  Copyright © 2017 Androoo. All rights reserved.
//

import UIKit

class LoadingViewController: UIViewController {
    
    //MARK: - Properties
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        get {
            return UIInterfaceOrientationMask.portrait
        }
    }
    
    //MARK: - Check if user is user is registered
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let userInformation = UserDefaults.standard.dictionary(forKey: "userInformation") {
            let email = userInformation["username"] as? String
            //User.login(withUsername: username, CloudKitId: IDK, completion)
            // dispatch to main and pushToVC
        } else {
            self.pushTo(viewController: .welcome)
        }
    }
    
    
    //MARK: - Push to relevant ViewController
    
    func pushTo(viewController: ViewControllerType) {
        switch viewController {
        case .conversations:
            guard let vc = storyboard?.instantiateViewController(withIdentifier: "Conversations") as? ChatsListTableViewController else { return }
            self.present(vc, animated: false, completion: nil)
        case .welcome:
            guard let vc = storyboard?.instantiateViewController(withIdentifier: "Welcome") as? WelcomeViewController else { return }
            self.present(vc, animated: false, completion: nil)
        }
    }
}
