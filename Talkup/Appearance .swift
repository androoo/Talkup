//
//  Appearance .swift
//  Talkup
//
//  Created by Andrew Ervin Gierke on 3/25/17.
//  Copyright © 2017 Androoo. All rights reserved.
//


import Foundation
import UIKit


//MARK: - Global Colors

struct Colors {
    static let blue = UIColor.init(red: 129/255.0, green: 144/255.0, blue: 255/255.0, alpha: 1)
    static let rose = UIColor.init(red: 254/255.0, green: 79/255.0, blue: 114/255.0, alpha: 1)
    static let purple = UIColor.init(red: 132/255.0, green: 66/255.0, blue: 249/255.0, alpha: 1)
    static let greenBlue = UIColor.init(red: 56/255.0, green: 197/255.0, blue: 221/255.0, alpha: 1)
    static let darkGreenBlue = UIColor.init(red: 25/255.0, green: 177/255.0, blue: 241/255.0, alpha: 1)
    static let gray = UIColor.init(red: 251/255.0, green: 251/255.0, blue: 251/255.0, alpha: 1)
    static let bubbleGray = UIColor.init(red: 242/255.0, green: 244/255.0, blue: 246/255.0, alpha: 1)
    static let buttonBorderGray = UIColor.init(red: 235/255.0, green: 235/255.0, blue: 235/255.0, alpha: 1)
    static let designBlue = UIColor.init(red: 45/255.0, green: 114/255.0, blue: 217/255.0, alpha: 1)
    static let hotRed = UIColor.init(red: 255/255.0, green: 45/255.0, blue: 85/255.0, alpha: 1)
    
    static let pureBlue = UIColor.init(red: 0/255.0, green: 101/255.0, blue: 255.0, alpha: 1)
    static let magenta = UIColor.init(red: 238/255.0, green: 29/255.0, blue: 176/255.0, alpha: 1)
    static let emeraldGreen = UIColor.init(red: 135/255.0, green: 228/255.0, blue: 18/255.0, alpha: 1)
    static let alertOrange = UIColor.init(red: 254/255.0, green: 188/255.0, blue: 70/255.0, alpha: 1)
    static let highlightGreenBlue = UIColor.init(red: 14/255.0, green: 194/255.0, blue: 243/255.0, alpha: 1)
    
    //gradient colors 
    
    static let blueTop = UIColor.init(red: 107/255.0, green: 151/255.0, blue: 252/255.0, alpha: 1)
    static let blueBottom = UIColor.init(red: 87/255.0, green: 130/255.0, blue: 252/255.0, alpha: 1)
    static let gradientBlue = UIColor.init(red: 82/255.0, green: 84/255.0, blue: 232/255.0, alpha: 1)
    static let gradientPurple = UIColor.init(red: 146/255.0, green: 97/255.0, blue: 234/255.0, alpha: 1)
    
    //text colors 
    static let recievedMessagePrimary = UIColor.init(red: 14/255.0, green: 15/255.0, blue: 15/255.0, alpha: 1)
    static let clearBlack = UIColor.init(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.25)
    
}

//MARK: - Gradients 

extension UIView {
    
    func applyGradient(colours: [UIColor]) -> Void {
        self.applyGradient(colours: colours, locations: nil)
    }
    
    func applyGradient(colours: [UIColor], locations: [NSNumber]?) -> Void {
        
        let gradient: CAGradientLayer = CAGradientLayer()
        
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.locations = locations
        self.layer.insertSublayer(gradient, at: 0)
    }
    
    func applyNavGradient(colours: [UIColor]) -> Void {
        self.applyNavGradient(colours: colours, locations: nil)
    }
    
    func applyNavGradient(colours: [UIColor], locations: [NSNumber]?) -> Void {
        
        let gradient: CAGradientLayer = CAGradientLayer()
        
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.locations = locations
        self.layer.insertSublayer(gradient, at: 0)
    }
}



//MARK: - UI Details

class RoundedButton: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        let radius: CGFloat = self.bounds.size.height / 2.0
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
    }
}


