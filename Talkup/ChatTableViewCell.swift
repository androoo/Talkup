//
//  ChatTableViewCell.swift
//  Talkup
//
//  Created by Andrew Ervin Gierke on 3/17/17.
//  Copyright © 2017 Androoo. All rights reserved.
//

import UIKit

class ChatTableViewCell: UITableViewCell {
    
    //MARK: - Properties
    
    @IBOutlet weak var chatRankLabel: UILabel!
    @IBOutlet weak var chatTopicLabel: UILabel!
    @IBOutlet weak var chatVoteCountLabel: UILabel!
    @IBOutlet weak var chatMessagesLabel: UILabel!
    @IBOutlet weak var hasReadBadgeBackgroundImageView: UIImageView!
    @IBOutlet weak var hasReadBadgeNumberLabel: UILabel!
    
    var chat: Chat? {
        didSet {
            updateViews()
        }
    }
    
    //MARK: - View lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()
        chatRankLabel.layer.cornerRadius = chatRankLabel.frame.width/2

    }
    
    private func updateViews() {
        guard let chat = chat else { return }
        chatTopicLabel.text = chat.topic
        chatRankLabel.text = "\(chat.score)"
        chatRankLabel.layer.cornerRadius = chatRankLabel.frame.width/2
    }
}
