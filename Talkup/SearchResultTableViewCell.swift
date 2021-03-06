//
//  SearchResultTableViewCell.swift
//  Talkup
//
//  Created by Andrew Ervin Gierke on 7/12/17.
//  Copyright © 2017 Androoo. All rights reserved.
//

import UIKit

class SearchResultTableViewCell: UITableViewCell {
    
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






