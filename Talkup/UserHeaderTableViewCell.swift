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
    
    var delegate: ChatHeaderDelegate?
    
    var user: User? {
        didSet {
            updateViews()
        }
    }
    
    var following: FollowingButton? {
        didSet {
            updateViews()
            followButtonAppearance()
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
        
        delegate?.followButtonPressed()
        
        if let following = following {
            
            switch following{
            case .active:
                
                followButton.backgroundColor = nil
                followButton.layer.borderColor = Colors.followingGreen.cgColor
                followButton.layer.borderWidth = 2
                followButton.tintColor = Colors.followingGreen
                followButton.setTitle("Follow", for: .normal)
                followButton.setTitleColor(Colors.followingGreen, for: .normal)
                followButton.layer.cornerRadius = followButton.layer.frame.height / 2
                followButton.layer.masksToBounds = true
                followButton.titleEdgeInsets = UIEdgeInsetsMake(4.0, 16.0, 4.0, 16.0)
                
                return
                
            case .resting:
                
                followButton.backgroundColor = Colors.followingGreen
                followButton.setTitle("Following", for: .normal)
                followButton.titleLabel?.textColor = .white
                followButton.setTitleColor(.white, for: .normal)
                followButton.layer.borderWidth = 0
                followButton.layer.cornerRadius = followButton.layer.frame.height / 2
                followButton.layer.masksToBounds = true
                followButton.titleEdgeInsets = UIEdgeInsetsMake(4.0, 16.0, 4.0, 16.0)
                
                return
                
            }
            
        }
    }
    
    @IBAction func editButtonTapped(_ sender: Any) {
        
    }
    
    //MARK: - Methods 
    
    func followButtonAppearance() {
        if following == .active {
            followButton.backgroundColor = Colors.followingGreen
            followButton.setTitle("Following", for: .normal)
            followButton.titleLabel?.textColor = .white
            followButton.setTitleColor(.white, for: .normal)
            followButton.layer.borderWidth = 0
            followButton.layer.cornerRadius = followButton.layer.frame.height / 2
            followButton.layer.masksToBounds = true
            followButton.titleEdgeInsets = UIEdgeInsetsMake(4.0, 16.0, 4.0, 16.0)
        } else {
            followButton.backgroundColor = nil
            followButton.layer.borderColor = Colors.followingGreen.cgColor
            followButton.layer.borderWidth = 2
            followButton.tintColor = Colors.followingGreen
            followButton.setTitle("Follow", for: .normal)
            followButton.setTitleColor(Colors.followingGreen, for: .normal)
            followButton.layer.cornerRadius = followButton.layer.frame.height / 2
            followButton.layer.masksToBounds = true
            followButton.titleEdgeInsets = UIEdgeInsetsMake(4.0, 16.0, 4.0, 16.0)
        }
    }
    
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
