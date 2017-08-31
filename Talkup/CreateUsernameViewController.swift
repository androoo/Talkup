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
    @IBOutlet weak var usernameWelcome: UILabel!
    @IBOutlet weak var usernameTooltip: UILabel!
    
    var accessCode: String?
    var username: String?
    let limitLength = 15
    let allUsernames = UserController.shared.allUsernames ?? ["andrew"]
    
    //MARK: - View lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        self.navigationController?.navigationBar.tintColor = .white
        
        continueButton.isEnabled = false
        UserController.shared.fetchAllUsernames {
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameTooltip.isHidden = true 
        
        continueButton.backgroundColor = Colors.bubbleGray
        continueButton.layer.cornerRadius = 8.0
        continueButton.layer.masksToBounds = true
        continueButton.setTitleColor(Colors.primaryDarkGray, for: .normal)
        
        usernameTextfield.delegate = self
        usernameTextfield.layer.borderWidth = 2.0
        usernameTextfield.layer.borderColor = Colors.primaryLightGray.cgColor
        usernameTextfield.layer.cornerRadius = 8.0
        usernameTextfield.textColor = Colors.conPurpleDark
        
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
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.usernameWelcome.isHidden = true
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
//        let allUsernames = UserController.shared.allUsernames
        
        if (allUsernames.contains(self.username!)) {
            return false
        } else {
            return true
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        guard let enteredUsername = textField.text, !enteredUsername.isEmpty else { return false }
        
//        let allUsernames = UserController.shared.allUsernames
        
        if (allUsernames.contains(enteredUsername)) {
            
        } else {
            performSegue(withIdentifier: "toAddUserPhoto", sender: self)
        }
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        // protect that text exists, and get that last character 
        guard let text = textField.text, !text.isEmpty else { return true }
        
//        let allUsernames = UserController.shared.allUsernames
        
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
        
        if (allUsernames.contains(newString)) {
            
            usernameTooltip.isHidden = false
            usernameTooltip.textColor = Colors.hotRed
            usernameTooltip.text = "Username is taken :("
            continueButton.isEnabled = false
            continueButton.backgroundColor = Colors.bubbleGray
            continueButton.setTitleColor(Colors.primaryDark, for: .normal)
            
        } else {
            
            usernameTooltip.isHidden = false
            usernameTooltip.textColor = Colors.emeraldGreen
            usernameTooltip.text = "Username is available!"
            continueButton.isEnabled = true
            continueButton.backgroundColor = Colors.conPurpleDark
            continueButton.setTitleColor(.white, for: .normal)
            
        }
        
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






