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
        
        searchBarStyle = UISearchBarStyle.default
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
            
            var bounds: CGRect
            bounds = searchField.frame
            bounds.size.height = 35 //(set height to whatever)
            searchField.bounds = bounds
            searchField.borderStyle = UITextBorderStyle.roundedRect
            searchField.backgroundColor = Colors.primaryLightGray
            searchField.layer.cornerRadius = 10.0
            searchField.frame = CGRect(x: 8.0, y: 30.0, width: frame.size.width - 86.0, height: 35.0)
            
            
            
            searchField.font = preferredFont
            searchField.textColor = preferredTextColor
            searchField.leftView = nil
            searchField.rightView = nil
            searchField.clearButtonMode = .never
            
            searchField.attributedPlaceholder = NSAttributedString(string: self.placeholder != nil ? self.placeholder! : "", attributes: [NSForegroundColorAttributeName: Colors.recievedMessagePrimary])
            
            searchField.backgroundColor = Colors.primaryLightGray
            
        }
        super.draw(rect)
    }
    
    
}













