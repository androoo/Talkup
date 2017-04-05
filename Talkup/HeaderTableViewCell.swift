//
//  HeaderTableViewCell.swift
//  Talkup
//
//  Created by Andrew Ervin Gierke on 4/5/17.
//  Copyright © 2017 Androoo. All rights reserved.
//

import UIKit

class HeaderTableViewCell: UITableViewCell {
    
    //MARK: - Properties 
    
    @IBOutlet weak var avatarImageView: UIImageView!
    
    //MARK: - Actions
    
    @IBOutlet weak var toProfileButton: UIButton!
    
    @IBAction func profileButtonTapped(_ sender: Any) {
        
        print("profile button tapped")
        
        let nc = NotificationCenter.default
        nc.post(name: Notifications.ProfileButtonTappedNotification, object: self)
        
    }

    

    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .clear
        avatarImageView.image = UserController.shared.currentUser?.photo
        avatarImageView.layer.cornerRadius = avatarImageView.frame.width / 2
        avatarImageView.clipsToBounds = true
    }

}
