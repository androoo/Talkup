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
        
        guard let chat = chat,
           let newestMessage = chat.messages.first else { return }
        
        if let author = newestMessage.owner {
            chatCreatorLabel.text = "\(author.userName):  \(newestMessage.text)"
        }
        
        creatorImageView.image = chat.creator?.photo
        chatTitleLabel.text = chat.topic
        
        
        
        
        creatorImageView.layer.cornerRadius = creatorImageView.frame.width / 2
        creatorImageView.clipsToBounds = true
        
        unreadBadgeBgImageView.layer.cornerRadius = unreadBadgeBgImageView.layer.frame.height / 2
        unreadBadgeBgImageView.clipsToBounds = true
        
        if chat.unreadMessages.count < 1 {
            unreadBadgeCountLabel.text = ""
            unreadBadgeBgImageView.backgroundColor = .white
        } else {
            unreadBadgeCountLabel.text = "\(chat.unreadMessages.count)"
            unreadBadgeBgImageView.backgroundColor = Colors.badgeOrange
        }
        
        unreadBadgeCountLabel.textColor = .white
        
    }

}
