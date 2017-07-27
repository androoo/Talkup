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
    @IBOutlet weak var cellBottomBorderSep: UIImageView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        let followingCount = ChatController.shared.followingChats.count
        
        backgroundColor = .white
        titleLabel.font = UIFont.appSectionHeaderFont
        titleLabel.textColor = Colors.greenBlue
        titleLabel.text = "FOLLOWING CHATS"
        cellBottomBorderSep.backgroundColor = Colors.buttonBorderGray
        
    }

}
