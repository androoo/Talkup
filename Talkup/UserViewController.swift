//
//  UserViewController.swift
//  Talkup
//
//  Created by Andrew Ervin Gierke on 4/5/17.
//  Copyright © 2017 Androoo. All rights reserved.
//

import UIKit

class UserViewController: UIViewController {
    
    //MARK: - Outlets
    
    @IBAction func backButtonTapped(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }

    var user: User?
    
    @IBOutlet weak var userAvatarImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateViews()
    }
    
    func updateViews() {
        userAvatarImageView.image = user?.photo
        usernameLabel.text = user?.userName
        userAvatarImageView.layer.cornerRadius = userAvatarImageView.frame.width / 2
        userAvatarImageView.clipsToBounds = true 
    }
}
