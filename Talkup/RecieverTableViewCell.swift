//
//  RecieverTableViewCell.swift
//  Talkup
//
//  Created by Andrew Ervin Gierke on 3/13/17.
//  Copyright © 2017 Androoo. All rights reserved.
//

import UIKit

//MARK: - Protocol

protocol MessageVoteButtonDelegate: class {
    func toggleVoteCount(_ sender: RecieverTableViewCell)
}

class RecieverTableViewCell: UITableViewCell {
    
    //MARK: - Properties
    
    var message: Message? {
        didSet {
            updateViews()
        }
    }
    
    //MARK: - Delegate
    
    weak var delegate: MessageVoteButtonDelegate?
    
    //MARK: - Outlets
    
    
    @IBOutlet weak var chatMessageLabel: UITextView!
    @IBOutlet weak var messageBackground: UIImageView!
    @IBOutlet weak var voteButton: UIButton!
    
    @IBOutlet weak var messageVoteCountLabel: UILabel!
    @IBOutlet weak var messageUsernameLabel: UILabel!
    @IBOutlet weak var messageDateLabel: UILabel!
    @IBOutlet weak var userAvatarImageView: UIImageView!
    
    
    
    @IBAction func recievedMessageCellVoteButtonTapped(_ sender: Any) {
        guard let message = message else { return }
        delegate?.toggleVoteCount(self)
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
        guard let message = message else { return }
        
        let time = message.timeSinceCreation(from: message.timestamp, to: Date())
        
        chatMessageLabel.text = message.text
        messageVoteCountLabel.text = "\(message.score)"
        messageUsernameLabel.text = message.owner?.userName
        messageDateLabel.text = "\(time)"
        userAvatarImageView.image = message.owner?.photo
        
        MessageController.shared.checkSubscriptionTo(messageNamed: message) { (subscribed) in
            
            let checkImage = subscribed ? #imageLiteral(resourceName: "downVote") : #imageLiteral(resourceName: "upVote")
            DispatchQueue.main.async {
                self.voteButton.setImage(checkImage, for: .normal)
            }
            
        }
        
    }
}
