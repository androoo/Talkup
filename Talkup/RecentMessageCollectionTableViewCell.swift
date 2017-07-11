//
//  RecentMessageCollectionTableViewCell.swift
//  Talkup
//
//  Created by Andrew Ervin Gierke on 7/10/17.
//  Copyright © 2017 Androoo. All rights reserved.
//

import UIKit

class RecentMessageCollectionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var recentMessagesTitleLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionView.backgroundColor = Colors.primaryLightGray
        recentMessagesTitleLabel.font = UIFont(name: "ArialRoundedMTBold", size: 36)
        recentMessagesTitleLabel.textColor = Colors.primaryDark
        recentMessagesTitleLabel.text = "🔥 Messages"
        
        
//        collectionView.applyGradient(colours: [Colors.gradientBlue, Colors.gradientPurple])
//        collectionView.applyGradient(colours: [Colors.purple, Colors.alertOrange], locations: [0.0, 1.0])
        
        
    }
}
