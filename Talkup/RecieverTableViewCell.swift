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
    
    @IBOutlet weak var messageScoreLabel: UILabel!
    @IBOutlet weak var userAvatarImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!

    @IBOutlet weak var voteButton: UIButton!
    @IBOutlet weak var buttonVoteCountLabel: UILabel!
    @IBOutlet weak var buttonVoteArrow: UIImageView!
    
    
    @IBAction func recievedMessageCellVoteButtonTapped(_ sender: UIButton) {
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
        
        messageScoreLabel.text = ""
        chatMessageLabel.text = message.text
        buttonVoteCountLabel.text = "\(message.score)"
        usernameLabel.text = message.owner?.userName
        timestampLabel.text = "\(time)"
        
        userAvatarImageView.image = message.owner?.photo
        userAvatarImageView.layer.cornerRadius = userAvatarImageView.frame.width/2
        userAvatarImageView.clipsToBounds = true 
        
        voteButton.backgroundColor = .clear
        voteButton.layer.cornerRadius = voteButton.frame.width/2
        voteButton.layer.borderWidth = 1
        voteButton.layer.borderColor = Colors.buttonBorderGray.cgColor
        buttonVoteCountLabel.textColor = .lightGray
        
        MessageController.shared.checkSubscriptionTo(messageNamed: message) { (subscribed) in
            
            //can do stuff here that changes appearance states depending on if the user is subscribed to the vote button or note
            
        }
        
    }
}
