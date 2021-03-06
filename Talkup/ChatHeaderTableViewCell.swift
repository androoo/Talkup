//
//  ChatHeaderTableViewCell.swift
//  Talkup
//
//  Created by Andrew Ervin Gierke on 7/4/17.
//  Copyright © 2017 Androoo. All rights reserved.
//

import UIKit

protocol ChatHeaderDelegate {
    func followButtonPressed()
}

class ChatHeaderTableViewCell: UITableViewCell {
    
    //MARK: - Properties 
    
    @IBOutlet weak var chatTitleLabel: UILabel!
    @IBOutlet weak var creatorButton: UIButton!
    @IBOutlet weak var membersLabel: UILabel!
    @IBOutlet weak var votesLabel: UILabel!
    @IBOutlet weak var creatorAvatarImageView: UIImageView!
    @IBOutlet weak var separatorImageView: UIImageView!
    @IBOutlet weak var followButton: UIButton!
    @IBOutlet weak var headerViewBgView: UIView!
    @IBOutlet weak var headerViewTopContstraint: NSLayoutConstraint!
    
    @IBOutlet weak var creatorUsernameLabel: UILabel!
    @IBOutlet weak var creatorTopSepImageView: UIImageView!
    
    @IBOutlet weak var userOneImageView: UIImageView!
    @IBOutlet weak var userTwoImageView: UIImageView!
    
    var delegate: ChatHeaderDelegate?
    
    var chat: Chat? {
        didSet {
            
        }
    }
    
    var following: FollowingButton? {
        didSet {
            updateViews()
            followButtonAppearance()
        }
    }
    
    var user: User? = UserController.shared.currentUser

    
    private func followButtonAppearance() {
        
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
    
    //MARK: - UI Actions
    
    @IBAction func creatorButtonTapped(_ sender: Any) {
        // TODO: - remove or reuse
    }
    
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
    
    func updateViews() {
        
        guard let chat = chat,
            let user = chat.creator else {
                return
        }
        
        headerViewBgView.backgroundColor = .white 
        
        chatTitleLabel.font = UIFont(name: "ArialRoundedMTBold", size: 48)
        chatTitleLabel.textColor = Colors.primaryDark
        chatTitleLabel.text = chat.topic
        creatorButton.tintColor = Colors.primaryDark
        creatorAvatarImageView.image = chat.creator?.photo
        creatorAvatarImageView.layer.cornerRadius = creatorAvatarImageView.layer.frame.width / 2
        creatorAvatarImageView.clipsToBounds = true
        separatorImageView.backgroundColor = Colors.bubbleGray
        membersLabel.textColor = Colors.primaryDarkGray
        votesLabel.textColor = Colors.primaryDarkGray
        creatorTopSepImageView.backgroundColor = Colors.primaryLightGray

        creatorUsernameLabel.text = user.userName
        creatorAvatarImageView.image = user.photo
        creatorTopSepImageView.backgroundColor = .clear
        creatorAvatarImageView.layer.cornerRadius = creatorAvatarImageView.layer.frame.height / 2
        
        votesLabel.text = "messages"
        membersLabel.text = "\(chat.messages.count)"
        
    }

}




