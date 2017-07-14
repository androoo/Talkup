//
//  MainSearchBar.swift
//  Talkup
//
//  Created by Andrew Ervin Gierke on 7/12/17.
//  Copyright © 2017 Androoo. All rights reserved.
//

import UIKit

class MainSearchBar: UISearchBar {
    
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
        
        if let index = indexOfSearchFieldInSubviews() {
            let searchField: UITextField = (subviews[0]).subviews[index] as! UITextField
            
            searchField.frame = CGRect(x: 8.0, y: 15.0, width: frame.size.width - 50.0, height: frame.size.height)
            searchField.font = preferredFont
            searchField.textColor = preferredTextColor
            searchField.leftView = nil
            searchField.rightView = nil
            searchField.clearButtonMode = .never
            
            searchField.attributedPlaceholder = NSAttributedString(string: self.placeholder != nil ? self.placeholder! : "", attributes: [NSForegroundColorAttributeName: Colors.recievedMessagePrimary])
            
            searchField.backgroundColor = Colors.primaryLightGray
            
            let startPoint = CGPoint(x: 0.0, y: frame.size.height)
            let endPoint = CGPoint(x: frame.size.width, y: frame.size.height)
            let path = UIBezierPath()
            
            path.move(to: startPoint)
            path.addLine(to: endPoint)
            
            let shapeLayer = CAShapeLayer()
            shapeLayer.path = path.cgPath
            shapeLayer.strokeColor = preferredTextColor.cgColor
            shapeLayer.lineWidth = 1.0
            
            layer.addSublayer(shapeLayer)
            
        }
        super.draw(rect)
    }
    
    
}













