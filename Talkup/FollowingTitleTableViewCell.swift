//
//  FollowingTitleTableViewCell.swift
//  Talkup
//
//  Created by Andrew Ervin Gierke on 5/7/17.
//  Copyright © 2017 Androoo. All rights reserved.
//

import UIKit

class FollowingTitleTableViewCell: UITableViewCell {
    
    //MARK: - Outlets 
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleBottomBorderImageView: UIImageView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        let followingCount = ChatController.shared.followingChats.count
        
        backgroundColor = .white
        titleLabel.font = UIFont(name: "ArialRoundedMTBold", size: 24)
        titleLabel.textColor = Colors.primaryDark
        titleLabel.text = "\(followingCount) Following"
        titleBottomBorderImageView.backgroundColor = Colors.flatYellow
    }

}
