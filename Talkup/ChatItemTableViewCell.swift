//
//  ChatItemTableViewCell.swift
//  Talkup
//
//  Created by Andrew Ervin Gierke on 4/8/17.
//  Copyright © 2017 Androoo. All rights reserved.
//

import UIKit

class ChatItemTableViewCell: UITableViewCell {
    
    //MARK: - Properties 
    
    var user: User?
    
    var chat: Chat? {
        didSet {
            updateViews()
        }
    }
    
    @IBOutlet weak var chatTitleLabel: UILabel!
    @IBOutlet weak var usersIconImageView: UIImageView!
    @IBOutlet weak var usersLabel: UILabel!
    
    @IBOutlet weak var avatarImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func updateViews() {
        chatTitleLabel.text = chat?.topic
        avatarImageView.image = user?.photo
        
        avatarImageView.layer.cornerRadius = avatarImageView.frame.width / 2
        avatarImageView.layer.masksToBounds = true 
        
    }
    
    

}
