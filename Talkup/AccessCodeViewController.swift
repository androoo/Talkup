//
//  AccessCodeViewController.swift
//  Talkup
//
//  Created by Andrew Ervin Gierke on 7/27/17.
//  Copyright © 2017 Androoo. All rights reserved.
//

import UIKit

class AccessCodeViewController: UIViewController, UITextFieldDelegate {
    
    //MARK: - Properties 
    
    @IBOutlet weak var scrollView: UIScrollView!
    var accessCodes: [String] = ["test1234"]
    
    @IBOutlet weak var accessCodeTextField: UITextField!
    @IBOutlet weak var requestCodeButton: UIButton!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var buttonsStackView: UIStackView!
    @IBOutlet weak var accessCodeWarningLabel: UILabel!
    
    
    //MARK: - UI Actions 
    
    
    
    
    //MARK: - View Lifecycle
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        requestCodeButton.layer.borderColor = UIColor.white.cgColor
        requestCodeButton.layer.borderWidth = 1
        requestCodeButton.layer.cornerRadius = 6.0
        requestCodeButton.layer.masksToBounds = true
        continueButton.layer.cornerRadius = 8.0
        continueButton.layer.masksToBounds = true
        continueButton.backgroundColor = .white
        accessCodeTextField.delegate = self
        accessCodeWarningLabel.isHidden = true
        accessCodeTextField.backgroundColor = UIColor(white: 1.0, alpha: 0.2)
        accessCodeTextField.textColor = Colors.conPurpleDark
        continueButton.isEnabled = false
        continueButton.backgroundColor = UIColor(white: 1.0, alpha: 0.15)
        continueButton.setTitleColor(Colors.conPurpleDark, for: .normal)
        registerForKeyboardNotifications()
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
    
    
    //MARK: - text field delegate 
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        
        accessCodeWarningLabel.textColor = Colors.deepPurple
        
        continueButton.backgroundColor = UIColor(white: 1.0, alpha: 1.0)
        continueButton.setTitleColor(Colors.conPurpleDark, for: .normal)
        
        accessCodeTextField.backgroundColor = UIColor(white: 1.0, alpha: 1.0)
        accessCodeTextField.textColor = Colors.conPurpleDark
        
    }
    
    
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        guard let enteredCode = textField.text else { return false }
        
        if self.accessCodes.contains(enteredCode) {
            
            accessCodeWarningLabel.isHidden = false
            accessCodeWarningLabel.textColor = Colors.deepPurple
            
            continueButton.backgroundColor = UIColor(white: 1.0, alpha: 1.0)
            continueButton.setTitleColor(Colors.conPurpleDark, for: .normal)
            
        }
        
        return true
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if (accessCodeTextField.text?.isEmpty)! {
            return false
        } else {
            return true
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        guard let accessCode = accessCodeTextField.text else { return true }
        
        if accessCodes.contains(accessCode) {
            performSegue(withIdentifier: "accessCodeSuccess", sender: self)
            
        } else {
            accessCodeWarningLabel.isHidden = false
//            requestCode()
        }
        
        return true
    }
    
    func requestCode() {
        
        let alertController = UIAlertController(title: "Request Access", message: "Send us your email address to request access", preferredStyle: .alert)
        let sendAction = UIAlertAction(title: "Send", style: .default) { (_) in
            print("send email")
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(sendAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
    }
    
}







