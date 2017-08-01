//
//  CreateUsernameViewController.swift
//  Talkup
//
//  Created by Andrew Ervin Gierke on 7/27/17.
//  Copyright © 2017 Androoo. All rights reserved.
//

import UIKit

class CreateUsernameViewController: UIViewController, UITextFieldDelegate {
    
    //MARK: - Properties 
    
    @IBOutlet weak var titleSubtext: UILabel!
    @IBOutlet weak var titleUsernameLabel: UILabel!
    @IBOutlet weak var usernameTextfield: UITextField!
    @IBOutlet weak var continueButton: UIButton!
    
    var username: String?
    
    //MARK: - View lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UserController.shared.fetchAllUsernames {
            
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // fetch all usernames to check against
        
        continueButton.layer.cornerRadius = 8.0
        continueButton.layer.masksToBounds = true
        usernameTextfield.delegate = self
    
    }
    
    
    //MARK: - Text Field Delegate 
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        username = textField.text
        
        return true
        
    }

    //MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }

    
}
