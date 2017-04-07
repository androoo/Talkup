//
//  ProfileViewController.swift
//  Talkup
//
//  Created by Andrew Ervin Gierke on 4/3/17.
//  Copyright © 2017 Androoo. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    //MARK: - Outlets
    
    @IBOutlet weak var avatarImageView: UIImageView!
    
    @IBOutlet weak var usernamtTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    
    @IBOutlet weak var nameLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isHidden = false 
        
        guard let user = UserController.shared.currentUser else { return }
        let name = user.userName
        
        
        avatarImageView.image = user.photo
        nameLabel.text = "Change Profile Photo"
        
        title = "Edit Profile"     
        
        nameLabel.textColor = Colors.designBlue
        navigationController?.navigationBar.tintColor = UIColor.darkGray
        
        avatarImageView.layer.cornerRadius = avatarImageView.frame.width / 2

        
        view.backgroundColor = .white
    }
    
    //MARK: - UI Actions
    
    @IBAction func CloseProfile(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    //Profile CRUD stuff

}
