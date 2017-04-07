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
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var newTopicLabel: UILabel!
    
    @IBOutlet weak var firstCellBackgroundView: UIView!
    
    
    //MARK: - View lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        updateViews()
        userAvatarImageView.layer.cornerRadius = userAvatarImageView.frame.width/2

    }
    
    
    private func updateViews() {
        
        newTopicLabel.text = "New Topic"
        newTopicLabel.textColor = Colors.actionBlue

        subTitleLabel.textColor = UIColor.gray
        
    }
}
