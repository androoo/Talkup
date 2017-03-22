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
        // check that username and email havent been used already 
        
        if let image = image,
            let username = usernameTextField.text,
            let email = emailTextField.text  {
            
            UserController.shared.createUserWith(username: username, email: email, image: image, completion: { (_) in
                
                // with completion you want to go to convo TV
                self.dismiss(animated: true, completion: nil)
            })
            
        } else {
            
            let alertController = UIAlertController(title: "Information Missing", message: "Check that you've filled out your email and username and try again", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            present(alertController, animated: true, completion: nil)
            
        }
        
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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
