//
//  EditProfileViewController.swift
//  Talkup
//
//  Created by Andrew Ervin Gierke on 8/18/17.
//  Copyright © 2017 Androoo. All rights reserved.
//

import UIKit

class EditProfileViewController: UIViewController, UITextFieldDelegate, EditPhotoViewControllerDelegate {

    //MARK: - Properties
    
    let limitLength = 15
    var username: String?
    var image: UIImage?
    
    var user: User? {
        
        didSet {
            if !isViewLoaded{
                loadView()
            }
            updateViews()
        }
        
    }
    
    //MARK: - UI Actions 
    
    @IBAction func exitButtonTapped(_ sender: Any) {
        
        dismiss(animated: true) { 
            
        }
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        
        guard let username = self.username,
            let image = self.image else {
                return
        }
        
//        UserController.shared.updateCurrentUser(username: username, photo: image, completion: { (user) in
//            self.updateViews()
//        })
        
        UserController.shared.updateUserOperation(userName: username, photo: image) { (user) in
            self.updateViews()
        }
        
    }
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    
    //MARK: - View lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UserController.shared.fetchAllUsernames {
            
        }
        performSegue(withIdentifier: "editPhoto", sender: self)
        usernameTextField.delegate = self
        usernameTextField.text = user?.userName
        
    }
    
    override func viewDidLoad() {
        
        usernameTextField.delegate = self
        usernameTextField.text = user?.userName
        
    }    
    
    
    //MARK: - UITextField Delegates
    
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
    
    func updateViews() {
        guard let user = user else { return }
        usernameTextField.text = self.username
        emailTextField.text = user.email
        view.backgroundColor = Colors.primaryLightGray
        self.image = user.photo
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "editPhoto" {
            let embededViewController = segue.destination as? EditPhotoViewController
            embededViewController?.delegate = self
            
        }
    }
    
    
    //MARK: - Photo delegate 
    
    func editPhotoViewControllerSelected(_ image: UIImage) {
        self.image = image
    }
}

