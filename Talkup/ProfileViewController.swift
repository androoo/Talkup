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
        
        guard let user = UserController.shared.currentUser else { return }
        let name = user.userName
        
        
        avatarImageView.image = user.photo
        nameLabel.text = "\(name)"
        
        usernamtTextField.text = UserController.shared.currentUser?.userName
        emailTextField.text = UserController.shared.currentUser?.email
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        
        view.backgroundColor = .clear
    }
    
    //Profile CRUD stuff

}
