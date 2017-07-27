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
    @IBOutlet weak var gradientBackGroundView: UIView!
    
    
    
    func setAppearance() {
        
            layoutSubviews()
            recentMessagesTitleLabel.font = UIFont.appSectionHeaderFont
            recentMessagesTitleLabel.textColor = Colors.badgeOrange
            recentMessagesTitleLabel.text = "TOP MESSAGES"
            gradientBackGroundView.backgroundColor = .clear
            gradientBackGroundView.applyGradient(colours: [.white, Colors.bubbleGray], locations: [0.0, 1.0])
            collectionView.backgroundColor = .clear
            
    }
    
    func setGradientBg() {
        
        let topColor = UIColor(red: (191/255.0), green: (143/255.0), blue: (248/255.0), alpha: 1)
        
        let bottomColor = UIColor(red: (131/255.0), green: (82/255.0), blue: (182/255.0), alpha: 1)
        
        
        let gradientColors: [CGColor] = [topColor.cgColor, bottomColor.cgColor]
        
        let gradientLoactions: [Float] = [0.0, 1.0]
        
        
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        
        gradientLayer.colors = gradientColors
        
        gradientLayer.locations = gradientLoactions as [NSNumber]
        
        
        gradientLayer.frame = self.gradientBackGroundView.bounds
        
        self.gradientBackGroundView = UIView()
        
        self.gradientBackGroundView.layer.insertSublayer(gradientLayer, at: 0)
        
    }
}
