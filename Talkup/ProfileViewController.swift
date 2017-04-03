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
    
    @IBOutlet weak var nameLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        print("profile scrolled")
        
        guard let user = UserController.shared.currentUser else { return }
        let name = user.userName
        
        view.backgroundColor = .clear
        
        avatarImageView.image = user.photo
        nameLabel.text = "\(name)"
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
    }
    
    //Profile CRUD stuff

}
