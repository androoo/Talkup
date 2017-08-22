//
//  AccessCodeViewController.swift
//  Talkup
//
//  Created by Andrew Ervin Gierke on 7/27/17.
//  Copyright © 2017 Androoo. All rights reserved.
//

import UIKit
import MessageUI

class AccessCodeViewController: UIViewController, UITextFieldDelegate, MFMailComposeViewControllerDelegate {
    
    //MARK: - Properties 
    
    var enteredCode: String?
    
    @IBOutlet weak var scrollView: UIScrollView!
    var accessCodes: [String] = ["test1234", "a", "devmtn", "talkupTest"]
    
    @IBOutlet weak var accessCodeTextField: UITextField!
    @IBOutlet weak var requestCodeButton: UIButton!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var buttonsStackView: UIStackView!
    @IBOutlet weak var accessCodeWarningLabel: UILabel!
    
    //MARK: - View Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        continueButton.isEnabled = false
        accessCodeTextField.text = ""
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        requestCodeButton.layer.borderColor = Colors.conPurpleDark.cgColor
        requestCodeButton.layer.borderWidth = 1
        requestCodeButton.layer.cornerRadius = 6.0
        requestCodeButton.layer.masksToBounds = true
        requestCodeButton.setTitleColor(Colors.conPurpleDark, for: .normal)
        
        continueButton.isEnabled = false
        continueButton.layer.cornerRadius = 8.0
        continueButton.layer.masksToBounds = true
        continueButton.backgroundColor = Colors.bubbleGray
        continueButton.setTitleColor(Colors.primaryDark, for: .normal)
        
        accessCodeWarningLabel.isHidden = true
        
        accessCodeTextField.delegate = self
        accessCodeTextField.layer.borderWidth = 2.0
        accessCodeTextField.layer.borderColor = Colors.primaryLightGray.cgColor
        accessCodeTextField.layer.cornerRadius = 8.0
        accessCodeTextField.textColor = Colors.conPurpleDark
        
        
        
        registerForKeyboardNotifications()
        registerForValidTextField()
    }
    
    //MARK: - UI Actions 
    
    @IBAction func continueButtonTapped(_ sender: Any) {
        
        
    }
    
    @IBAction func requestCodeButtonTapped(_ sender: Any) {
        self.requestCode()
    }
    
    
    
    //MARK: - Handle Keyboard 
    
    func registerForValidTextField() {
        accessCodeTextField.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
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
    
    // enable continue button if code is valid 
    
    func editingChanged(_ textField: UITextField) {
        guard let text = textField.text else { return }
        
        if accessCodes.contains(text) {
            
            continueButton.isEnabled = true
            
        }
        
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
        
        accessCodeTextField.layer.borderColor = Colors.conPurpleDark.cgColor
        accessCodeTextField.layer.borderWidth = 2
        accessCodeTextField.layer.cornerRadius = 8.0
        accessCodeTextField.textColor = Colors.primaryDark
        
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
        } else if (!accessCodes.contains(self.enteredCode!)) {
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
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        // protect that text exists, and get that last character
        guard let text = textField.text else { return true }
        let newString = NSString(string: text).replacingCharacters(in: range, with: string)
    
        self.enteredCode = newString
        
        if (accessCodes.contains(newString)) {
            accessCodeWarningLabel.isHidden = false
            accessCodeWarningLabel.textColor = Colors.emeraldGreen
            accessCodeWarningLabel.text = "Yay! that'll work."
            continueButton.backgroundColor = Colors.conPurpleDark
            continueButton.setTitleColor(.white, for: .normal)
            
        } else {
            accessCodeWarningLabel.isHidden = false
            accessCodeWarningLabel.textColor = Colors.hotRed
            accessCodeWarningLabel.text = "Bummer, that's not correct."
            continueButton.backgroundColor = Colors.bubbleGray
            continueButton.setTitleColor(Colors.primaryDark, for: .normal)
        }
        
        return true
        
    }
    
    func requestCode() {
        
        let alertController = UIAlertController(title: "Request Access", message: "Send us your email address to request access", preferredStyle: .alert)
        let sendAction = UIAlertAction(title: "Send", style: .default) { (_) in
            
            if !MFMailComposeViewController.canSendMail() {
                print("Mail services are not available")
                return
            }
            
            self.sendEmail()
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
        
        if segue.identifier == "accessCodeSuccess" {
            let destination = segue.destination as? CreateUsernameViewController
            destination?.accessCode = enteredCode
        }
    }
    
    func updateViews() {
        
    }
    
    //MARK: - Mail Helpers
    
    func sendEmail() {
        let composeVC = MFMailComposeViewController()
        composeVC.mailComposeDelegate = self
        // Configure the fields of the interface.
        composeVC.setToRecipients(["andrew@and.studio"])
        composeVC.setSubject("Talkup Access Code Please :)")
        composeVC.setMessageBody("Hello. I'd like to give Talkup a try!", isHTML: false)
        // Present the view controller modally.
        self.present(composeVC, animated: true, completion: nil)
    }
    
    func mailComposeController(controller: MFMailComposeViewController,
                               didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        // Check the result or perform other tasks.
        // Dismiss the mail compose view controller.
        controller.dismiss(animated: true, completion: nil)
    }
    
}







