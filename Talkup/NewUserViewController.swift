//
//  NewUserViewController.swift
//  Talkup
//
//  Created by Andrew Ervin Gierke on 3/22/17.
//  Copyright © 2017 Androoo. All rights reserved.
//

import UIKit

class NewUserViewController: UIViewController {
    
    //MARK: - Properties
    
    //need to get username and photo
    
    var image: UIImage?
    
    @IBOutlet weak var emailTextField: UITextField!
    
    //MARK: - UI Actions
    
//    @IBAction func signUpButtonTapped(_ sender: Any) {
//        
//        guard let username = usernameTextField.text,
//            let email = emailTextField.text,
//            let image = image else { emptyFieldsAlert(); return }
//        
//        UserController.shared.createUserWith(username: username, email: email, image: image) { (user) in
//            
//            //send to convo TVC
//            DispatchQueue.main.async {
//                
//            guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "MainNavigation") as? PageViewController else { return }
//            self.present(vc, animated: false, completion: nil)
//                
//            }
//        }
//    }
}
