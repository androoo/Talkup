//
//  CustomSearchBar.swift
//  Talkup
//
//  Created by Andrew Ervin Gierke on 5/4/17.
//  Copyright © 2017 Androoo. All rights reserved.
//

import UIKit

class CustomSearchBar: UISearchBar {

    //MARK: - Properties 
    
    var preferredFont: UIFont!
    var preferredTextColor: UIColor!
    
    init(frame: CGRect, font: UIFont, textColor: UIColor) {
        
        super.init(frame: frame)
        
        self.frame = frame
        preferredFont = font
        preferredTextColor = textColor
        
        
        searchBarStyle = UISearchBarStyle.prominent
        isTranslucent = false
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    
    func indexOfSearchFieldInSubviews() -> Int! {
        
        var index: Int!
        let searchBarView = subviews[0] as UIView
        
        for i in 0 ..< searchBarView.subviews.count {
            if searchBarView.subviews[i].isKind(of: UITextField.self) {
                index = i
            }
        }
        
        return index
        
    }
    
    override func draw(_ rect: CGRect) {
        
        // Find the index of the search field in the searchbars subviews
        if let index = indexOfSearchFieldInSubviews() {
            
            // Access the search field
            let searchField: UITextField = (subviews[0]).subviews[index] as! UITextField
            
            // Set its frame 
            searchField.frame = CGRect(x: 5.0, y: 5.0, width: frame.size.width - 10.0, height: frame.size.width - 10.0)
            
            // Set the font and text color of the search field 
            searchField.font = preferredFont
            searchField.textColor = preferredTextColor
            
            // Set the icons
            
            searchField.leftView = nil
            searchField.rightView = nil
            
            searchField.clearButtonMode = .never
            
            
            // Set the background color 
            searchField.backgroundColor = barTintColor
            
            let startPoint = CGPoint(x: 0.0, y: frame.size.height)
            let endPoint = CGPoint(x: frame.size.width, y: frame.size.height)
            let path = UIBezierPath()
            
            path.move(to: startPoint)
            path.addLine(to: endPoint)
            
            let shapeLayer = CAShapeLayer()
            shapeLayer.path = path.cgPath
            shapeLayer.strokeColor = preferredTextColor.cgColor
            shapeLayer.lineWidth = 2.5
            
            layer.addSublayer(shapeLayer)
            
        }
        super.draw(rect)
    }

}
