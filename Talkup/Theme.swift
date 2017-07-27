//
//  Theme.swift
//  Talkup
//
//  Created by Andrew Ervin Gierke on 7/19/17.
//  Copyright © 2017 Androoo. All rights reserved.
//

import UIKit

// Text styles

extension UIFont {
    static var appNavigationButtonLeftFont: UIFont {
        return UIFont.systemFont(ofSize: 5.67, weight: UIFontWeightRegular)
    }
    
    static var appCommentFont: UIFont {
        return UIFont.systemFont(ofSize: 13.0, weight: UIFontWeightRegular)
    }
    
    static var appActionSheetDescriptionFont: UIFont {
        return UIFont.systemFont(ofSize: 4.33, weight: UIFontWeightRegular)
    }
    
    static var appTabBarTextFont: UIFont {
        return UIFont.systemFont(ofSize: 3.33, weight: UIFontWeightRegular)
    }
    
    static var appSectionHeaderFont: UIFont {
        return UIFont(name: "Gotham-Black", size: 24.0)!
    }
    
    static var appWelcomeTitlerFont: UIFont {
        return UIFont(name: "Gotham-Black", size: 16.0)!
    }
}
