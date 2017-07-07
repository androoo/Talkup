//
//  ChatHeaderTableViewCell.swift
//  Talkup
//
//  Created by Andrew Ervin Gierke on 7/4/17.
//  Copyright © 2017 Androoo. All rights reserved.
//

import UIKit

protocol ChatHeaderDelegate {
    func followButtonPressed(_ sender: ChatHeaderTableViewCell)
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
    
    var delegate: ChatHeaderDelegate?
    
    var chat: Chat? {
        didSet {
            updateViews()
        }
    }
    
    var following: FollowingButton? {
        didSet {
            
            checkFollowing()
            
        }
    }
    
    func checkFollowing() {
        
        guard let chat = chat else { return }
        
        ChatController.shared.checkSubscriptionTo(chat: chat) { (subscription) in
            if subscription {
                self.following = .pressed
                
            } else {
                self.following = .notPressed
            }
            
            DispatchQueue.main.async {
                self.followButtonAppearance()
            }
        }
    }
    
    func followButtonAppearance() {
        if following == .pressed {
            followButton.backgroundColor = Colors.primaryBgPurple
            followButton.setTitle("Following", for: .normal)
//            followButton.titleLabel?.text = "Following"
            followButton.titleLabel?.textColor = .white
            followButton.layer.borderWidth = 0
        } else {
            followButton.backgroundColor = nil
            followButton.layer.borderColor = Colors.primaryBgPurple.cgColor
            followButton.layer.borderWidth = 2
            followButton.tintColor = Colors.primaryBgPurple
            followButton.setTitle("Follow", for: .normal)
        }
    }
    
    //MARK: - UI Actions
    
    @IBAction func creatorButtonTapped(_ sender: Any) {
        
    }
    
    @IBAction func followButtonTapped(_ sender: Any) {
        
        if followButton.titleLabel?.text == "Follow" {
            delegate?.followButtonPressed(self)
            followButton.backgroundColor = Colors.primaryBgPurple
            followButton.setTitle("Following", for: .selected)
            followButton.layer.borderWidth = 0
        } else {
            followButton.backgroundColor = nil
            followButton.layer.borderColor = Colors.primaryBgPurple.cgColor
            followButton.layer.borderWidth = 2
            followButton.tintColor = Colors.primaryBgPurple
            followButton.setTitle("Follow", for: .normal)
        }
        
    }
    
    func updateViews() {
        
        chatTitleLabel.font = UIFont(name: "ArialRoundedMTBold", size: 48)
        chatTitleLabel.textColor = Colors.primaryDark
        chatTitleLabel.text = chat?.topic
        creatorButton.tintColor = Colors.primaryBgPurple
        creatorAvatarImageView.image = chat?.creator?.photo
        creatorAvatarImageView.layer.cornerRadius = creatorAvatarImageView.layer.frame.width / 2
        creatorAvatarImageView.clipsToBounds = true 
        creatorButton.setTitle(chat?.creator?.userName, for: .normal)
        separatorImageView.backgroundColor = Colors.bubbleGray
        membersLabel.textColor = Colors.primaryDarkGray
        votesLabel.textColor = Colors.primaryDarkGray
        
        followButton.layer.borderColor = Colors.primaryBgPurple.cgColor
        followButton.layer.borderWidth = 2
        followButton.tintColor = Colors.primaryBgPurple
        followButton.layer.cornerRadius = followButton.layer.frame.height / 2
        followButton.layer.masksToBounds = true
        followButton.setTitle("Follow", for: .normal)
        followButton.titleEdgeInsets = UIEdgeInsetsMake(4.0, 16.0, 4.0, 16.0)

        
    }

}




