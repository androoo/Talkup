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
    
    
    
    //MARK: - setup Methods
    
    func clearCellData() {
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    private func updateViews() {
        guard let chat = chat else { return }
        
            chatTopicLabel.text = chat.topic
            
        
    }
}
