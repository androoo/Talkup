//
//  UserHeaderTableViewCell.swift
//  Talkup
//
//  Created by Andrew Ervin Gierke on 8/8/17.
//  Copyright © 2017 Androoo. All rights reserved.
//

import UIKit

class UserHeaderTableViewCell: UITableViewCell {
    
    //MARK: - Outlets 
    
    @IBOutlet weak var userAvatarImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userFollowButton: RoundedCornerButton!
    @IBOutlet weak var headerBgView: UIView!
    
    
    //MARK: - UI Actions 
    
    @IBAction func followButtonTapped(_ sender: Any) {
    }
    

}
