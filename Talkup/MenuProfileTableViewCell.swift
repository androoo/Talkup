//
//  MenuProfileTableViewCell.swift
//  Talkup
//
//  Created by Andrew Ervin Gierke on 7/17/17.
//  Copyright © 2017 Androoo. All rights reserved.
//

import UIKit

protocol MenuDelegate {
    func selectedRow(index: Int)
}

class MenuProfileTableViewCell: UITableViewCell {
    
    //MARK: - Properties
    
    var delegate: MenuDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.delegate?.selectedRow(index: 1)
    }
    
    var title: String? {
        didSet {
            updateViews()
        }
    }
    
    @IBOutlet weak var menuItemIconImageView: UIImageView!
    @IBOutlet weak var menuItemNameLabel: UILabel!
    
    func updateViews() {
        
        menuItemNameLabel.text = title
        menuItemIconImageView.alpha = 0.35
        
        menuItemIconImageView.image = UIImage(named: "profile")
        
    }

}
