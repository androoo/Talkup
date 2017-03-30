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
    static let gray = UIColor.init(red: 251/255.0, green: 251/255.0, blue: 251/255.0, alpha: 1)
    static let buttonBorderGray = UIColor.init(red: 235/255.0, green: 235/255.0, blue: 235/255.0, alpha: 1)
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


