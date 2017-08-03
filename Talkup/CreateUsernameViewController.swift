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
    
    var accessCode: String?
    var username: String?
    let limitLength = 15
    
    //MARK: - View lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.tintColor = .white
        UserController.shared.fetchAllUsernames {
            
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        continueButton.layer.cornerRadius = 8.0
        continueButton.layer.masksToBounds = true
        usernameTextfield.delegate = self
        registerForKeyboardNotifications()
        registerForTextFieldLengthNotification()
    }
    
    //MARK: - Handle Keyboard
    
    func registerForTextFieldLengthNotification() {
    }
    
    func registerForKeyboardNotifications() {
        // Adding notification on keyboard appearing
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func deRegisterFromKeyboardNotifications() {
        // Remove notificaiton on keyboard activity
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func keyboardWasShown(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
        
    }
    
    func keyboardWillBeHidden(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }
    
    
    //MARK: - Text Field Delegate 
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        guard let enteredUsername = textField.text,
           let allUsernames = UserController.shared.allUsernames else { return false }
        
        if allUsernames.contains(enteredUsername) {
            // handle username taken
        } else {
            performSegue(withIdentifier: "toAddUserPhoto", sender: self)
        }
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        // protect that text exists, and get that last character 
        guard let text = textField.text else { return true }
        let newString = NSString(string: text).replacingCharacters(in: range, with: string)
        
        // define invalid char set
        var invalidCharSet = NSCharacterSet.whitespacesAndNewlines
        let uppercaseSet = NSCharacterSet.uppercaseLetters
        invalidCharSet.formUnion(uppercaseSet)
        
        // handle invalid characters in entry
        if let _ = string.rangeOfCharacter(from: invalidCharSet) {
            return false
        }
        
        // check length limit
        let newLength = newString.characters.count + string.characters.count - range.length
        
        self.username = newString
        
        return newLength <= limitLength
        
    }
    

    //MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
        
        if segue.identifier == "toAddUserPhoto" {
            if let detailViewController = segue.destination as? NewUserAvatarViewController {
                
                detailViewController.username = self.username
                detailViewController.accessCode = self.accessCode
            }
        }
    }
    
}






