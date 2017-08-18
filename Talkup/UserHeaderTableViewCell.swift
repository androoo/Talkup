//
//  UserHeaderTableViewCell.swift
//  Talkup
//
//  Created by Andrew Ervin Gierke on 8/8/17.
//  Copyright © 2017 Androoo. All rights reserved.
//

import UIKit

class UserHeaderTableViewCell: UITableViewCell {
    
    //MARK: - Properties
    
    var user: User? {
        didSet {
            updateViews()
        }
    }
    
    
    //MARK: - Outlets 
    
    @IBOutlet weak var userAvatarImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userFollowButton: RoundedCornerButton!
    @IBOutlet weak var headerBgView: UIView!
    @IBOutlet weak var headerViewBottomSep: UIImageView!
    
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var followButton: RoundedCornerButton!
    
    //MARK: - UI Actions 
    
    @IBAction func followButtonTapped(_ sender: Any) {
        
    }
    
    @IBAction func editButtonTapped(_ sender: Any) {
        
    }
    
    //MARK: - Methods 
    
    func updateViews() {
        guard let user = user else { return }
        
        userNameLabel.text = user.userName
        userAvatarImageView.image = user.photo
        userAvatarImageView.layer.cornerRadius = userAvatarImageView.frame.width / 2
        userAvatarImageView.layer.masksToBounds = true 
        headerViewBottomSep.backgroundColor = Colors.primaryLightGray
        headerBgView.backgroundColor = Colors.primaryLightGray
    }
    

}
