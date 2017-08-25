//
//  TopicCellTableViewCell.swift
//  Talkup
//
//  Created by Andrew Ervin Gierke on 8/18/17.
//  Copyright © 2017 Androoo. All rights reserved.
//

import UIKit

class TopicCellTableViewCell: UITableViewCell {

    var user: User?
    
    var chat: Chat? {
        didSet {
            DispatchQueue.main.async {
                self.updateViews()
            }
        }
    }
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var topicNameLabel: UILabel!
    @IBOutlet weak var creatorImageView: UIImageView!
    
    func updateViews() {
        topicNameLabel.text = chat?.topic
        usernameLabel.text = user?.userName
        creatorImageView.image = user?.photo
        
        creatorImageView.layer.cornerRadius = creatorImageView.layer.frame.width / 2
        creatorImageView.layer.masksToBounds = true
        usernameLabel.textColor = Colors.primaryDarkGray
        
    }
    
}
