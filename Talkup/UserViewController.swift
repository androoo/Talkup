//
//  UserViewController.swift
//  Talkup
//
//  Created by Andrew Ervin Gierke on 4/5/17.
//  Copyright © 2017 Androoo. All rights reserved.
//

import UIKit

class UserViewController: UIViewController {
    
    //MARK: - Outlets
    

    
    var user: User? {
        didSet {
            updateViews()
        }
    }
    
    @IBOutlet weak var userAvatarImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func updateViews() {
        userAvatarImageView.image = user?.photo
        usernameLabel.text = user?.userName
    }
}
