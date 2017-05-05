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
    static let greenBlueLight = UIColor.init(red: 56/255.0, green: 197/255.0, blue: 221/255.0, alpha: 0.15)
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
    static let alertOrangeLight = UIColor.init(red: 255/255.0, green: 245/255.0, blue: 228/255.0, alpha: 1)
    static let highlightGreenBlue = UIColor.init(red: 14/255.0, green: 194/255.0, blue: 243/255.0, alpha: 1)
    static let hightlightBlue = UIColor.init(red: 250/255.0, green: 253/255.0, blue: 255/255.0, alpha: 1)
    static let sepBlue = UIColor.init(red: 231/255.0, green: 246/255.0, blue: 255/255.0, alpha: 1)
    static let actionBlue = UIColor.init(red: 13/255.0, green: 153/255.0, blue: 229/255.0, alpha: 1)
    
    static let lightblue = UIColor.init(red: 242/255.0, green: 250/255.0, blue: 252/255.0, alpha: 1)
    static let navbarGray = UIColor.init(red: 249/255.0, green: 249/255.0, blue: 249/255.0, alpha: 1)
    
    static let conPurpleDark = UIColor.init(red: 78/255.0, green: 35/255.0, blue: 229/255.0, alpha: 1)
    static let conPurpleLight = UIColor.init(red: 140/255.0, green: 84/255.0, blue: 249/255.0, alpha: 1)
    static let conGreenDark = UIColor.init(red: 44/255.0, green: 197/255.0, blue: 238/255.0, alpha: 1)
    static let conGreenLight = UIColor.init(red: 116/255.0, green: 224/255.0, blue: 247/255.0, alpha: 1)
    static let conPinkDark = UIColor.init(red: 243/255.0, green: 117/255.0, blue: 246/255.0, alpha: 1)
    static let conPinkLight = UIColor.init(red: 254/255.0, green: 156/255.0, blue: 213/255.0, alpha: 1)
    static let deepPurple = UIColor.init(red: 36/255.0, green: 25/255.0, blue: 84/255.0, alpha: 1)
    
    //gradient colors 
    
    static let blueTop = UIColor.init(red: 107/255.0, green: 151/255.0, blue: 252/255.0, alpha: 1)
    static let blueBottom = UIColor.init(red: 87/255.0, green: 130/255.0, blue: 252/255.0, alpha: 1)
    static let gradientBlue = UIColor.init(red: 82/255.0, green: 84/255.0, blue: 232/255.0, alpha: 1)
    static let gradientPurple = UIColor.init(red: 146/255.0, green: 97/255.0, blue: 234/255.0, alpha: 1)
    
    //text colors 
    static let recievedMessagePrimary = UIColor.init(red: 14/255.0, green: 15/255.0, blue: 15/255.0, alpha: 1)
    static let clearBlack = UIColor.init(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.25)
    static let addBlue = UIColor.init(red: 39/255.0, green: 150/255.0, blue: 252/255.0, alpha: 1)
    
    //v2 colors 
    static let flatPurple = UIColor.init(red: 181/255.0, green: 37/255.0, blue: 243/255.0, alpha: 1)
    static let flatYellow = UIColor.init(red: 255/255.0, green: 203/255.0, blue: 93/255.0, alpha: 1)
    static let messagePurple = UIColor.init(red: 100/255.0, green: 63/255.0, blue: 237/255.0, alpha: 1)
    static let messageBlue = UIColor.init(red: 47/255.0, green: 140/255.0, blue: 255/255.0, alpha: 1)
    static let tableCellBgBlue = UIColor.init(red: 249/255.0, green: 253/255.0, blue: 254/255.0, alpha: 1)
    static let tableCellSepBlue = UIColor.init(red: 225/255.0, green: 247/255.0, blue: 250/255.0, alpha: 1)
    static let primaryBlueGreen = UIColor.init(red: 56/255.0, green: 197/255.0, blue: 221/255.0, alpha: 1)
    static let primaryBgPurple = UIColor.init(red: 129/255.0, green: 80/255.0, blue: 231/255.0, alpha: 1)
    static let tableViewBgPurple = UIColor.init(red: 251/255.0, green: 249/255.0, blue: 254/255.0, alpha: 1)
    static let tableViewSepPurple = UIColor.init(red: 236/255.0, green: 229/255.0, blue: 252/255.0, alpha: 1)
    
    static let primaryDark = UIColor.init(red: 48/255.0, green: 54/255.0, blue: 67/255.0, alpha: 1)
    static let primaryLightGray = UIColor.init(red: 243/255.0, green: 245/255.0, blue: 248/255.0, alpha: 1)
    static let primaryDarkGray = UIColor.init(red: 193/255.0, green: 201/255.0, blue: 219/255.0, alpha: 1)
    
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
    
    func imageWithGradient(img:UIImage!) -> UIImage {
        
        UIGraphicsBeginImageContext(img.size)
        let context = UIGraphicsGetCurrentContext()
        
        img.draw(at: CGPoint(x: 0, y: 0))
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let locations:[CGFloat] = [0.0, 1.0]
        
        let bottom = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5).cgColor
        let top = UIColor(red: 0, green: 0, blue: 0, alpha: 0).cgColor
        
        let colors = [top, bottom] as CFArray
        
        let gradient = CGGradient(colorsSpace: colorSpace, colors: colors, locations: locations)
        
        let startPoint = CGPoint(x: img.size.width/2, y: 0)
        let endPoint = CGPoint(x: img.size.width/2, y: img.size.height)
        
        context!.drawLinearGradient(gradient!, start: startPoint, end: endPoint, options: CGGradientDrawingOptions(rawValue: UInt32(0)))
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return image!
    }
    
    func dropShadow() {
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.25
        self.layer.shadowOffset = CGSize(width: -1, height: 1)
        self.layer.shadowRadius = 1
        
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = true 
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


