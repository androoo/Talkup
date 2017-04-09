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
    
    @IBOutlet weak var chatTitleLabel: UILabel!
    @IBOutlet weak var usersIconImageView: UIImageView!
    @IBOutlet weak var usersLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
