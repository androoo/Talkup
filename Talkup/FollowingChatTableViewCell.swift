//
//  FollowingChatTableViewCell.swift
//  Talkup
//
//  Created by Andrew Ervin Gierke on 5/7/17.
//  Copyright © 2017 Androoo. All rights reserved.
//

import UIKit

class FollowingChatTableViewCell: UITableViewCell {
    
    //MARK: - Properties 
    
    var chat: Chat? {
        didSet {
            updateViews()
        }
    }
    
    // need to know how many unreads there are 
    
    
    
    //MARK: - Outlets 
    
    @IBOutlet weak var creatorImageView: UIImageView!
    @IBOutlet weak var chatTitleLabel: UILabel!
    @IBOutlet weak var chatCreatorLabel: UILabel!
    
    @IBOutlet weak var unreadBadgeBgImageView: UIImageView!
    @IBOutlet weak var unreadBadgeCountLabel: UILabel!
    
    
    //MARK: - Helper methods 
    
    func updateViews() {
        
        guard let chat = chat else { return }
        
        creatorImageView.image = chat.creator?.photo
        chatTitleLabel.text = chat.topic
        chatCreatorLabel.text = chat.creator?.userName
        
        creatorImageView.layer.cornerRadius = creatorImageView.frame.width / 2
        creatorImageView.clipsToBounds = true
        
        unreadBadgeBgImageView.backgroundColor = Colors.badgeOrange
        unreadBadgeBgImageView.layer.cornerRadius = unreadBadgeBgImageView.layer.frame.width / 2
        unreadBadgeBgImageView.clipsToBounds = true
        
        unreadBadgeCountLabel.textColor = .white 
        unreadBadgeCountLabel.text = "12"
        
    }

}
