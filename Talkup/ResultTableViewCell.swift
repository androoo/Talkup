//
//  ResultTableViewCell.swift
//  Talkup
//
//  Created by Andrew Ervin Gierke on 5/6/17.
//  Copyright © 2017 Androoo. All rights reserved.
//

import UIKit

class ResultTableViewCell: UITableViewCell {
    
    //MARK: - Outlets 
    
    @IBOutlet weak var userAvatarImageView: UIImageView!
    @IBOutlet weak var chatTitleLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    
    
    //MARK: - Properties
    
    var chat: Chat? {
        didSet {
            updateViews()
        }
    }
    
    
    //MARK: - View life

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK: - Helper Methods 
    
    func updateViews() {
        guard let chat = chat,
            let creator = chat.creator else { return }
        
        userAvatarImageView.image = creator.photo
        chatTitleLabel.text = "\(chat.topic)"
        userNameLabel.text = "by \(creator.userName)"
        
        userAvatarImageView.layer.cornerRadius = userAvatarImageView.frame.width / 2
        userAvatarImageView.clipsToBounds = true 
        
        chatTitleLabel.textColor = Colors.primaryDark
        userNameLabel.textColor = Colors.primaryDarkGray
        
    }
}
