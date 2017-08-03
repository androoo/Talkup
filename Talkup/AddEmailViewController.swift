//
//  AddEmailViewController.swift
//  Talkup
//
//  Created by Andrew Ervin Gierke on 3/22/17.
//  Copyright © 2017 Androoo. All rights reserved.
//

import UIKit

class AddEmailViewController: UIViewController, UITextFieldDelegate {
    
    //MARK: - Properties
    
    var image: UIImage?
    var userName: String?
    var email: String?
    var accessCode: String?
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var continueButtonTapped: UIButton!
    @IBOutlet weak var invalidEmailWarningLabel: UILabel!
    
    //MARK: - UI Actions
    
    @IBAction func signUpButtonTapped(_ sender: Any) {
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.tintColor = .white
    }
    
    //MARK: - View lifecycle 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        continueButtonTapped.layer.cornerRadius = 8.0
        continueButtonTapped.layer.masksToBounds = true
        emailTextField.delegate = self
        registerForKeyboardNotifications()
        invalidEmailWarningLabel.isHidden = true
        
    }
    
    //MARK: - Handle Keyboard
    
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

        // check that text field is a valid email address
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        
        if emailTest.evaluate(with: textField.text) == false {
            invalidEmailWarningLabel.isHidden = false
            invalidEmailWarningLabel.text = "please enter a valid email address"
            invalidEmailWarningLabel.textColor = UIColor(white: 1.0, alpha: 0.3)
        } else {
            invalidEmailWarningLabel.isHidden = true
        }
        
        self.email = textField.text
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
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
        
        self.email = newString
        
        return true
        
    }
    
    //MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
        
        if segue.identifier == "toCreateNewUser" {
            if let detailViewController = segue.destination as? CreateAccountViewController {
                detailViewController.username = self.userName
                detailViewController.email = self.email
                detailViewController.image = self.image
                detailViewController.accessCode = self.accessCode
            }
        }
    }
    
}





