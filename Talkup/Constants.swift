//
//  Constants.swift
//  Talkup
//
//  Created by Andrew Ervin Gierke on 3/14/17.
//  Copyright © 2017 Androoo. All rights reserved.
//

import Foundation

struct Constants {
    
    //MARK: - Segues 
    
    static let toChats = "toChats"
    static let toWelcome = "toWelcome"
    static let toHome = "toHome"
    static let toProfile = "toProfile"
        
    //MARK: - User Keys
    
    static let usertypeKey = "User"
    static let photoDataKey = "photoData"
    static let usernameKey = "username"
    static let userEmailKey = "email"
    static let userReferenceKey = "userReference"
    static let blockedReferenceKey = "blockedReference"
    
    //MARK: - Chat Keys
    
    static let chattypeKey = "Chat"
    static let chatTopicKey = "topic"
    static let usersKey = "users"
    static let messagesKey = "messages"
    static let chatReferenceKey = "chatReference"
    static let chatCreatorKey = "creator"
    
    //MARK: - Message Keys
    
    static let messagetypeKey = "Message"
    static let messageReferenceKey = "message"
    static let ownerKey = "owner"
    static let chatKey = "chat"
    static let timestampKey = "timestamp"
    static let textKey = "text"
    static let hasReadKey = "read"
    static let scoreKey = "score"
    
    
   
}
