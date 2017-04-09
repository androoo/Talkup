//
//  TopTableViewCell.swift
//  Talkup
//
//  Created by Andrew Ervin Gierke on 4/8/17.
//  Copyright © 2017 Androoo. All rights reserved.
//

import UIKit

class TopTableViewCell: UITableViewCell {
    
    //MARK: - Properties
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        updateViews()
    }
    
    func updateViews() {
    }

}
