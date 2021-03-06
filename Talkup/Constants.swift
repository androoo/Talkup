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
    static let toChatDetail = "toChatDetail"
    static let toUserDetail = "toUserDetail"
        
    //MARK: - User Keys
    
    static let usertypeKey = "User"
    static let photoDataKey = "photoData"
    static let usernameKey = "username"
    static let userEmailKey = "email"
    static let userReferenceKey = "userReference"
    static let followingReferenceKey = "followingReference"
    static let unreadMessagesReferenceKey = "unreadReference"
    static let blockedReferenceKey = "blockedReference"
    static let unreadKey = "unread"
    static let authorized = "authorized"
    static let accessCode = "accessCode"
    
    //MARK: - Chat Keys
    
    static let chattypeKey = "Chat"
    static let chatTopicKey = "topic"
    static let usersKey = "users"
    static let messagesKey = "messages"
    static let chatReferenceKey = "chatReference"
    static let chatTimestampKey = "chatTimestamp"
    static let chatCreatorKey = "creator"
    static let isDirectKey = "isDirect"
    static let unreadMessages = "unreadChat"
    
    //MARK: - Message Keys
    
    static let messagetypeKey = "Message"
    static let messageReferenceKey = "message"
    static let ownerKey = "owner"
    static let chatKey = "chat"
    static let profileKey = "profile"
    static let timestampKey = "timestamp"
    static let textKey = "text"
    static let blockedKey = "blocked"
    static let scoreKey = "score"
    
    
    //MARK: - Custom Cell Types 
    
    static let chatFilterHeaderKey = "headerViewCell"
    static let chatHeaderCellKey = "headerCell"
    static let sentMessageKey = "senderCell"
    static let recievedMessageKey = "recieverCell"
    
    
   
}
