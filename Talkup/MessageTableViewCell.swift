//
//  MessageTableViewCell.swift
//  Talkup
//
//  Created by Andrew Ervin Gierke on 3/13/17.
//  Copyright © 2017 Androoo. All rights reserved.
//

import UIKit

class MessageTableViewCell: UITableViewCell {
    
    //MARK: - Properties
    
    var chat: Chat? {
        didSet {
            updateViews()
        }
    }
    
    //MARK: - Outlets
    
    @IBOutlet weak var chatTopicLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var chatCountLabel: UILabel!
    @IBOutlet weak var topicNumberLabel: UILabel!
    @IBOutlet weak var hasReadAlertNumber: UILabel!
    @IBOutlet weak var hasReadAlertBg: UIImageView!
    @IBOutlet weak var chatMessageLabel: UITextView!
    @IBOutlet weak var messageBackground: UIImageView!
    @IBOutlet weak var voteButton: UIButton!
    
    
    @IBAction func voteButtonTapped(_ sender: Any) {
    }
    
    
    //MARK: - setup Methods
    
    func clearCellData() {
        self.chatMessageLabel.text = nil
        self.chatMessageLabel.isHidden = false
        self.messageBackground.image = nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        guard let messageToCustomize = chatMessageLabel, let messageBg = messageBackground else { return }
        
        self.selectionStyle = .none
        
        messageToCustomize.textContainerInset = UIEdgeInsetsMake(5, 5, 5, 5)
        messageBg.layer.cornerRadius = 15
        messageBg.clipsToBounds = true
        
    }
    
    private func updateViews() {
        guard let chat = chat else { return }
        chatTopicLabel.text = chat.topic
        scoreLabel.text = "\(chat.score)"
        
    }
}
