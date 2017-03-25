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

struct GlobalVariables {
    static let blue = UIColor.init(red: 129/255.0, green: 144/255.0, blue: 255/255.0, alpha: 1)
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
