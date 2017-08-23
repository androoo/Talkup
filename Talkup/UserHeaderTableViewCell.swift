//
//  UserHeaderTableViewCell.swift
//  Talkup
//
//  Created by Andrew Ervin Gierke on 8/8/17.
//  Copyright © 2017 Androoo. All rights reserved.
//

import UIKit

class UserHeaderTableViewCell: UITableViewCell {
    
    //MARK: - Properties
    
    var user: User? {
        didSet {
            updateViews()
        }
    }
    
    
    //MARK: - Outlets 
    
    @IBOutlet weak var userAvatarImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userFollowButton: RoundedCornerButton!
    @IBOutlet weak var headerBgView: UIView!
    @IBOutlet weak var headerViewBottomSep: UIImageView!
    
    @IBOutlet weak var userCreatedChatsCountLabel: UILabel!
    @IBOutlet weak var chatsLabel: UILabel!
    @IBOutlet weak var chatsCountTopSep: UIImageView!
    
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var followButton: RoundedCornerButton!
    
    //MARK: - UI Actions 
    
    @IBAction func followButtonTapped(_ sender: Any) {
        
    }
    
    @IBAction func editButtonTapped(_ sender: Any) {
        
    }
    
    //MARK: - Methods 
    
    func updateViews() {
        guard let user = user else { return }
        
        userNameLabel.text = user.userName
        userAvatarImageView.image = user.photo
        userAvatarImageView.layer.cornerRadius = userAvatarImageView.frame.width / 2
        userAvatarImageView.layer.masksToBounds = true 
        headerViewBottomSep.backgroundColor = Colors.primaryLightGray
        headerBgView.backgroundColor = Colors.primaryLightGray
        
        chatsCountTopSep.backgroundColor = .clear
        chatsLabel.textColor = Colors.primaryDarkGray
        userCreatedChatsCountLabel.text = "\(user.chats.count)"
        
        editButton.backgroundColor = nil
        editButton.layer.borderColor = Colors.primaryDarkGray.cgColor
        editButton.layer.borderWidth = 2
        editButton.setTitleColor(Colors.primaryDarkGray, for: .normal)
        editButton.setTitle("Edit Profile", for: .normal)
        editButton.layer.cornerRadius = editButton.layer.frame.height / 2
        editButton.titleEdgeInsets = UIEdgeInsetsMake(4.0, 16.0, 4.0, 16.0)
        
    }
    

}
