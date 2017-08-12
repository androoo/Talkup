//
//  CreateAccountViewController.swift
//  Talkup
//
//  Created by Andrew Ervin Gierke on 8/1/17.
//  Copyright © 2017 Androoo. All rights reserved.
//

import UIKit

class CreateAccountViewController: UIViewController {
    
    //MARK: - Properties
    var username: String?
    var email: String?
    var image: UIImage?
    var accessCode: String?
    
    
    //MARK: - Outlets
    
    @IBOutlet weak var userAvatarImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var createAccountButton: UIButton!
    
    
    //MARK: - UI Actions
    
    @IBAction func createAccountButtonTapped(_ sender: Any) {
        
        guard let username = username,
            let email = email,
            let accessCode = accessCode,
            let image = image ?? UIImage(named: "defaultUser") else { emptyFieldsAlert(); return }
        
        UserController.shared.createUserWith(username: username, email: email, image: image, accessCode: accessCode) { (user) in
            
            //send to convo TVC
            DispatchQueue.main.async {
                
                guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "MainNav") else { return }
                self.present(vc, animated: false, completion: nil)
                
            }
            // can create user direct chat channel here 
            
            guard let createdUser = user else { return }
            
            ChatController.shared.createChatWith(chatTopic: username, owner: createdUser, firstMessage: "hi", isDirectChat: true, completion: { (_) in
                // whatever
            })
        }
    }
    
    
    //MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userAvatarImageView.layer.cornerRadius = userAvatarImageView.layer.frame.width / 2
        userAvatarImageView.layer.masksToBounds = true
        createAccountButton.layer.cornerRadius = 8.0
        createAccountButton.layer.masksToBounds = true
        
        usernameLabel.text = self.username
        usernameLabel.textColor = Colors.messagePurple
        userAvatarImageView.image = self.image ?? UIImage(named: "defaultUser")
        
    }
    
    //MARK: - Empty Alert
    
    func emptyFieldsAlert() {
        
    }
    
}
