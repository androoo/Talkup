//
//  MessageItemCollectionViewCell.swift
//  Talkup
//
//  Created by Andrew Ervin Gierke on 7/10/17.
//  Copyright © 2017 Androoo. All rights reserved.
//

import UIKit

class MessageItemCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Properties 
    
    var isWidthCalculated: Bool = false
    
    var message: Message? {
        didSet {
            updateViews()
        }
    }
    
    //MARK: - Outlets
    
    @IBOutlet weak var messageBubbleBgImageView: UIImageView!
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var voteButtonBgView: UIView!
    @IBOutlet weak var voteButtonVoteArrowImageView: UIImageView!
    @IBOutlet weak var voteButtonVoteCountlabel: UILabel!
    @IBOutlet weak var messageAuthorImageView: UIImageView!
    @IBOutlet weak var messageAuthorNameButton: UIButton!
    @IBOutlet weak var viteButtonArrowImageView: UIImageView!
    
    //MARK: - UIActions 
    
    @IBAction func messageVoteButton(_ sender: Any) {
        
    }
    
    @IBAction func messageAuthorNameButtonTapped(_ sender: Any) {
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
        
    }
    
    //MARK: - Helpers 
    
    func updateViews() {
        
        guard let message = message else {
                return
        }
        
        self.voteButtonAppearance()
        
        messageBubbleBgImageView.backgroundColor = Colors.primaryBgPurple
        messageTextView.text = message.text
        messageBubbleBgImageView.layer.cornerRadius = 22
        messageAuthorImageView.image = message.owner?.photo
        messageAuthorImageView.layer.cornerRadius = messageAuthorImageView.frame.width / 2
        messageAuthorImageView.layer.masksToBounds = true
        messageAuthorNameButton.setTitle("\(message.owner?.userName ?? "username")", for: .normal)
        messageAuthorNameButton.tintColor = Colors.primaryDarkGray
        voteButtonVoteCountlabel.text = "\(message.score)"

    }
    
    func voteButtonAppearance() {
        
        voteButtonBgView.layer.cornerRadius = voteButtonBgView.frame.width / 2
        voteButtonBgView.layer.masksToBounds = true
        voteButtonBgView.backgroundColor = Colors.greenBlue
        voteButtonVoteArrowImageView.image = UIImage(named: "upVoteWhite")
        voteButtonVoteCountlabel.textColor = .white
        
        
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        
        if !isWidthCalculated {
            
            setNeedsLayout()
            layoutIfNeeded()
            let size = contentView.systemLayoutSizeFitting(layoutAttributes.size)
            var newFrame = layoutAttributes.frame
            newFrame.size.width = CGFloat((message?.text.size().width)!)
            layoutAttributes.frame = newFrame
            isWidthCalculated = true
            
        }
        return layoutAttributes
    }
    
}








