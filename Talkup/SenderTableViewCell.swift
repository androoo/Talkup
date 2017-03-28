//
//  SenderTableViewCell.swift
//  Talkup
//
//  Created by Andrew Ervin Gierke on 3/21/17.
//  Copyright © 2017 Androoo. All rights reserved.
//

import UIKit

class SenderTableViewCell: UITableViewCell {
    
    //MARK: - Properties 
    
    var message: Message? {
        didSet {
            updateViews()
        }
    }

    //MARK: - Outlets
    
    @IBOutlet weak var chatCountLabel: UILabel!
    @IBOutlet weak var ownerAvatarImageView: UIImageView!
    @IBOutlet weak var timestampLabel: UILabel!
    
    @IBOutlet weak var chatTextView: UITextView!
    @IBOutlet weak var chatBubbleBackgroundImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        guard let messageToCustomize = chatTextView, let messageBg = chatBubbleBackgroundImageView else { return }
        self.selectionStyle = .none
        
        messageToCustomize.textContainerInset = UIEdgeInsetsMake(5, 5, 5, 5)
        messageBg.layer.cornerRadius = 15
        messageBg.clipsToBounds = true
        
    }
    
    private func updateViews() {
        guard let message = message else { return }
        
        let time = message.timeSinceCreation(from: message.timestamp, to: Date())
        
        chatTextView.text = message.text
        chatCountLabel.text = "\(message.score)"
        ownerAvatarImageView.image = message.owner?.photo
        timestampLabel.text = "\(time)"
    
    }

}










