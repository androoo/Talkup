//
//  ChatHeaderTableViewCell.swift
//  Talkup
//
//  Created by Andrew Ervin Gierke on 7/4/17.
//  Copyright © 2017 Androoo. All rights reserved.
//

import UIKit

class ChatHeaderTableViewCell: UITableViewCell {
    
    //MARK: - Properties 
    
    @IBOutlet weak var chatTitleLabel: UILabel!
    @IBOutlet weak var creatorButton: UIButton!
    @IBOutlet weak var membersLabel: UILabel!
    @IBOutlet weak var votesLabel: UILabel!
    @IBOutlet weak var creatorAvatarImageView: UIImageView!
    @IBOutlet weak var separatorImageView: UIImageView!
    
    
    var chat: Chat? {
        didSet {
            updateViews()
        }
    }
    
    
    //MARK: - UI Actions
    
    @IBAction func creatorButtonTapped(_ sender: Any) {
        
    }
    
    
    func updateViews() {
        
        chatTitleLabel.font = UIFont(name: "ArialRoundedMTBold", size: 28)
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
        
    }

}




