//
//  SenderTableViewCell.swift
//  Talkup
//
//  Created by Andrew Ervin Gierke on 3/21/17.
//  Copyright © 2017 Androoo. All rights reserved.
//

import UIKit

class SenderTableViewCell: UITableViewCell {

    //MARK: - Outlets
    
    @IBOutlet weak var chatCountLabel: UILabel!
    @IBOutlet weak var ownerAvatarImageView: UIImageView!
    @IBOutlet weak var timestampLabel: UILabel!
    
    @IBOutlet weak var chatTextView: UITextView!
    @IBOutlet weak var chatBubbleBackgroundImageView: UIImageView!

}
