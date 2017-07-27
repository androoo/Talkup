//
//  FilterTableViewCell.swift
//  Talkup
//
//  Created by Andrew Ervin Gierke on 4/5/17.
//  Copyright © 2017 Androoo. All rights reserved.
//

import UIKit

class FilterTableViewCell: UITableViewCell {
    
    //MARK: - Properties 
    
    @IBOutlet weak var SectionLabel: UILabel!
    @IBOutlet weak var bottomBorderSep: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .white
        SectionLabel.font = UIFont.appSectionHeaderFont
        SectionLabel.textColor = Colors.alertOrange
        SectionLabel.text = "TRENDING TOPICS"
        
        
    }
}
