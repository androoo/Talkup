//
//  MenuTableViewCell.swift
//  Talkup
//
//  Created by Andrew Ervin Gierke on 7/17/17.
//  Copyright © 2017 Androoo. All rights reserved.
//

import UIKit

class MenuTableViewCell: UITableViewCell {
    
    //MARK: - Properties
    
    var itemName: String? {
        didSet {
            updateViews()
        }
    }
    
    @IBOutlet weak var menuItemIconImageView: UIImageView!
    @IBOutlet weak var menuItemNameLabel: UILabel!
    
    func updateViews() {
        menuItemNameLabel.text = itemName
    }

}