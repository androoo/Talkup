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

enum FeedFilter {
    case trending
    case following
    case recent
    case featured
}

enum ViewControllerType {
    case conversations
    case welcome
}

enum PhotoSource {
    case library
    case camera
}

enum VoteButtonState {
    case noVote
    case yesVote
}

enum FollowingButton {
    case active
    case resting
}

enum MessageType {
    case photo
    case text
    case location
}

enum MessageOwner {
    case sender
    case receiver 
}

enum MessageSort {
    case live
    case top
}

enum ReadState {
    case read
    case unread
}


