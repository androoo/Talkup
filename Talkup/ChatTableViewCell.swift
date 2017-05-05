//
//  ChatTableViewCell.swift
//  Talkup
//
//  Created by Andrew Ervin Gierke on 3/17/17.
//  Copyright © 2017 Androoo. All rights reserved.
//

import UIKit

class ChatTableViewCell: UITableViewCell {
    
    //MARK: - Properties
    
    @IBOutlet weak var userAvatarImageView: UIImageView!
    @IBOutlet weak var chatRankLabel: UILabel!
    @IBOutlet weak var chatTopicLabel: UILabel!
    @IBOutlet weak var hasReadBadgeBackgroundImageView: UIImageView!
    @IBOutlet weak var hasReadBadgeNumberLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    
    @IBOutlet weak var toUserArrow: UIImageView!
    
    
    var chat: Chat? {
        didSet {
            updateViews()
        }
    }
    
    //MARK: - View lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()
        chatRankLabel.layer.cornerRadius = chatRankLabel.frame.width/2
        userAvatarImageView.layer.cornerRadius = userAvatarImageView.frame.width/2
        hasReadBadgeBackgroundImageView.isHidden = true
    }
    
    private func updateViews() {
        guard let chat = chat,
            let creator = chat.creator else { return }

        
        chatTopicLabel.text = chat.topic
        chatTopicLabel.textColor = Colors.primaryDark
        chatRankLabel.text = "\(chat.score)"
        chatRankLabel.textColor = Colors.primaryDark
        subTitleLabel.textColor = Colors.primaryDarkGray
        userAvatarImageView.image = creator.photo
        subTitleLabel.text = "by \(creator.userName)"
        
        toUserArrow.tintColor = Colors.actionBlue
    }
}
