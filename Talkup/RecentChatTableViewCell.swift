//
//  RecentChatTableViewCell.swift
//  Talkup
//
//  Created by Andrew Ervin Gierke on 8/16/17.
//  Copyright © 2017 Androoo. All rights reserved.
//

import UIKit

class RecentChatTableViewCell: UITableViewCell {
    
    //MARK: - Properties 
    
    var chat: Chat? {
        didSet {
            updateViews()
        }
    }
    
    //MARK: - Outlets
    
    @IBOutlet weak var createdByUserImageView: UIImageView!
    @IBOutlet weak var chatTitleLabel: UILabel!
    @IBOutlet weak var creatorInfoLabel: UILabel!
    @IBOutlet weak var datelabel: UILabel!
    
    //MARK: - Methods 
    
    func updateViews() {
        
        guard let chat = chat,
            let user = chat.creator else {
                return
        }
        
        let dateFormatter = DateFormatter()
        let timeSince = dateFormatter.timeSince(from: chat.timestamp as NSDate, numericDates: true)
        
        chatTitleLabel.text = chat.topic
        createdByUserImageView.image = user.photo
        createdByUserImageView.layer.cornerRadius = createdByUserImageView.layer.frame.width / 2
        createdByUserImageView.layer.masksToBounds = true
        creatorInfoLabel.text = user.userName
        datelabel.text = timeSince
        datelabel.textColor = Colors.primaryDark
        
    }
}
