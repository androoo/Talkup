//
//  EditProfileViewController.swift
//  Talkup
//
//  Created by Andrew Ervin Gierke on 8/18/17.
//  Copyright © 2017 Androoo. All rights reserved.
//

import UIKit

class EditProfileViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate {

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
    
    @IBOutlet weak var userAvatarImageView: UIImageView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var navBarBottomSep: UIImageView!
    @IBOutlet weak var edtiViewTopSep: UIImageView!
    @IBOutlet weak var editViewBottomSep: UIImageView!
    
    @IBOutlet weak var textEditBgView: UIView!
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
        
        UserController.shared.updateUserOperation(userName: username, photo: image) { (user) in
            self.updateViews()
        }
        
    }
    
    
    //MARK: - View lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UserController.shared.fetchAllUsernames {
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isHidden = true
        
        usernameTextField.delegate = self
        usernameTextField.text = user?.userName
        view.backgroundColor = Colors.primaryLightGray
        textEditBgView.backgroundColor = .white
        navBarBottomSep.backgroundColor = Colors.primaryDarkGray
        editViewBottomSep.backgroundColor = Colors.primaryDarkGray
        edtiViewTopSep.backgroundColor = Colors.primaryDarkGray
        
        usernameTextField.text = user?.userName
        
    }
    
    
    //MARK: - Photo Selector Delegate
    
    @IBAction func photoButtonTapped(_ sender: Any) {
        
        let imagePicker = UIImagePickerController()
        
        let alert = UIAlertController(title: "Select Photo Location", message: nil, preferredStyle: .actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            alert.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (_) in
                imagePicker.sourceType = .photoLibrary
                self.present(imagePicker, animated: true, completion: nil)
            }))
        }
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (_) in
                imagePicker.sourceType = .camera
                self.present(imagePicker, animated: true, completion: nil)
            }))
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
        
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        /// chcek if you can return edited image that user choose it if user already edit it(crop it), return it as image
        if let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            
            /// if user update it and already got it , just return it to 'self.imgView.image'
            self.image = editedImage
            
            /// else if you could't find the edited image that means user select original image same is it without editing .
        } else if let orginalImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            /// if user update it and already got it , just return it to 'self.imgView.image'.
            self.image = orginalImage
        }
        else { print ("error") }
        
        /// if the request successfully done just dismiss
        
        picker.dismiss(animated: true, completion: nil)
        updateViews()
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
    
    
    //MARK: - Helper Methods 
    
    func updateViews() {
        guard let user = user else { return }
        usernameTextField.text = self.username
        view.backgroundColor = Colors.primaryLightGray
        self.image = user.photo
    }
    
}

