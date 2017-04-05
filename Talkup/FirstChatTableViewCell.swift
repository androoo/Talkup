//
//  FirstChatTableViewCell.swift
//  Talkup
//
//  Created by Andrew Ervin Gierke on 4/5/17.
//  Copyright © 2017 Androoo. All rights reserved.
//

import UIKit

class FirstChatTableViewCell: UITableViewCell {

    //MARK: - Properties
    
    @IBOutlet weak var userAvatarImageView: UIImageView!
    @IBOutlet weak var chatTopicLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    
    @IBOutlet weak var firstCellBackgroundView: UIView!
    
    var chat: Chat? {
        didSet {
            updateViews()
        }
    }
    
    //MARK: - View lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()

        userAvatarImageView.layer.cornerRadius = userAvatarImageView.frame.width/2

    }
    
    
    private func updateViews() {
        guard let chat = chat,
            let creator = chat.creator else { return }
        
        chatTopicLabel.text = chat.topic

        subTitleLabel.textColor = .lightGray
        userAvatarImageView.image = creator.photo
        subTitleLabel.text = "by \(creator.userName)"
        

        
        
    }
}
