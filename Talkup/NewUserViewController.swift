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
    
    var image: UIImage?
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    //MARK: - UI Actions
    
    @IBAction func signUpButtonTapped(_ sender: Any) {
        
        guard let username = usernameTextField.text,
            let email = emailTextField.text,
            let image = image else { emptyFieldsAlert(); return }
        
        UserController.shared.createUserWith(username: username, email: email, image: image) { (user) in
            
            //send to convo TVC
            DispatchQueue.main.async {
                
            guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "MainNavigation") as? PageViewController else { return }
            self.present(vc, animated: false, completion: nil)
                
            }
        }
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func emptyFieldsAlert() {
        let alertController = UIAlertController(title: "Information Missing", message: "Check that you've added a profile image, filled out your email + username and try again", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    //MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "embedPhotoSelect" {
            let embedViewController = segue.destination as? PhotoSelectViewController
            embedViewController?.delegate = self
        }
    }
}

extension NewUserViewController: PhotoSelectViewControllerDelegate {
    func photoSelectViewControllerSelected(_ image: UIImage) {
        self.image = image
    }
}
