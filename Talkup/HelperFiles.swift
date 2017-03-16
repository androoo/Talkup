//
//  HelperFiles.swift
//  Talkup
//
//  Created by Andrew Ervin Gierke on 3/13/17.
//  Copyright © 2017 Androoo. All rights reserved.
//

import Foundation
import UIKit


//MARK: - Global variables 

struct GlobalVariables {
    static let blue = UIColor.init(red: 129/255.0, green: 144/255.0, blue: 255/255.0, alpha: 1)
}

//MARK: - Extensions 

class RoundedButton: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        let radius: CGFloat = self.bounds.size.height / 2.0
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
    }
}

//MARK: - Enums 

enum ViewControllerType {
    case conversations
    case welcome
}

enum PhotoSource {
    case library
    case camera
}

enum MessageType {
    case photo
    case text
}

enum MessageOwner {
    case sender
    case receiver 
}


