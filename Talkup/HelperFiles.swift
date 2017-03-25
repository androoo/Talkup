//
//  HelperFiles.swift
//  Talkup
//
//  Created by Andrew Ervin Gierke on 3/13/17.
//  Copyright © 2017 Androoo. All rights reserved.
//

import Foundation
import UIKit


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

enum MessageSort {
    case live
    case top
}


