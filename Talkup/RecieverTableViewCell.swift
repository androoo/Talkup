//
//  RecieverTableViewCell.swift
//  Talkup
//
//  Created by Andrew Ervin Gierke on 3/13/17.
//  Copyright © 2017 Androoo. All rights reserved.
//

import UIKit

//MARK: - Protocol

protocol RecieverTableViewCellDelegate {
    func toggleVoteCount(_ sender: RecieverTableViewCell)
    func reportAbuse(_ sender: RecieverTableViewCell)
    func usernameClicked(user: User)
}


class RecieverTableViewCell: UITableViewCell {
    
    //MARK: - Properties
    
    var message: Message? {
        didSet {
            updateViews()
        }
    }
    
    var voteButtonState: VoteButtonState?
    
    //MARK: - Delegate
    
    var delegate: RecieverTableViewCellDelegate?
    
    //MARK: - Outlets
    
    
    @IBOutlet weak var chatMessageLabel: UITextView!
    @IBOutlet weak var messageBackground: UIImageView!
    
    @IBOutlet weak var messageScoreLabel: UILabel!
    @IBOutlet weak var userAvatarImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var usernameButton: UIButton!
    
    
    @IBOutlet weak var flagIcon: UIButton!
    
    @IBOutlet weak var voteButtonView: UIView!

    @IBOutlet weak var voteButton: UIButton!
    @IBOutlet weak var buttonVoteCountLabel: UILabel!
    @IBOutlet weak var buttonVoteArrow: UIImageView!
    
    @IBOutlet weak var userActionsButton: UIButton!

    @IBAction func userActionsButtonTapped(_ sender: Any) {
        delegate?.reportAbuse(self)
    }
    
    @IBAction func recievedMessageCellVoteButtonTapped(_ sender: UIButton) {
        guard let message = message else { return }
        
        // switch local appearance
        voteButtonAppearance()
        
        //disable
        voteButton.isEnabled = false
        
        //update subscription and score to cloud
        delegate?.toggleVoteCount(self)
        
        
    }
    

    @IBAction func usernameButtonWasTapped(_ sender: Any) {
        guard let user = message?.owner
            else { return }
        delegate?.usernameClicked(user: user)
    }
    
    
    func voteButtonAppearance() {
        
        //toggle vote button appearance
        
        if voteButtonState == .yesVote {
            
            voteButton.backgroundColor = Colors.gradientPurple
            
            voteButton.layer.cornerRadius = voteButton.frame.width/2
            voteButton.layer.borderWidth = 1
            voteButton.layer.borderColor = Colors.gradientPurple.cgColor
            
            buttonVoteCountLabel.textColor = .white
            buttonVoteArrow.image = UIImage(named: "upVoteWhite")
            
            message?.score -= 1
            
            voteButtonState = .noVote
            
            
        } else {
            
            voteButton.backgroundColor = .clear
            voteButton.layer.cornerRadius = voteButton.frame.width/2
            voteButton.layer.borderWidth = 1
            voteButton.layer.borderColor = Colors.buttonBorderGray.cgColor
            
            buttonVoteArrow.image = UIImage(named: "upVoteBlack")
            buttonVoteCountLabel.textColor = .lightGray
            
            message?.score += 1
            
            voteButtonState = .yesVote
        }
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
        
        guard let message = message,
            let username = message.owner?.userName else { return }
        
        let time = message.timeSinceCreation(from: message.timestamp, to: Date())
      
        
        messageScoreLabel.text = ""
        chatMessageLabel.text = message.text
        buttonVoteCountLabel.text = "\(message.score)"
        timestampLabel.text = "\(time)"
        usernameButton.setTitle("\(username)", for: .normal)
        
        userAvatarImageView.image = message.owner?.photo
        userAvatarImageView.layer.cornerRadius = userAvatarImageView.frame.width/2
        userAvatarImageView.clipsToBounds = true
        
        messageBackground.backgroundColor = Colors.bubbleGray
        messageBackground.layer.cornerRadius = 20
        chatMessageLabel.textColor = .black 
        
        MessageController.shared.checkSubscriptionTo(messageNamed: message) { (subscription) in
            
            if subscription {
                self.voteButtonState = .yesVote
                
            } else {
                self.voteButtonState = .noVote
            }
            
            DispatchQueue.main.async {
                self.voteButtonAppearance()
            }
        }
    }
}
