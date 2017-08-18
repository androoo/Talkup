//
//  EditProfileViewController.swift
//  Talkup
//
//  Created by Andrew Ervin Gierke on 8/18/17.
//  Copyright © 2017 Androoo. All rights reserved.
//

import UIKit

class EditProfileViewController: UIViewController {

    var user: User? {
        didSet {
            
            if !isViewLoaded{
                loadView()
            }
            
            updateViews()
        }
    }
    
    @IBOutlet weak var userImageView: UIImageView!
    
    @IBAction func exitButtonTapped(_ sender: Any) {
        dismiss(animated: true) { 
            
        }
    }
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    func updateViews() {
        guard let user = user else { return }
        userImageView.image = user.photo
        usernameTextField.text = user.userName
        emailTextField.text = user.email
    }

}
