//
//  TopTableViewCell.swift
//  Talkup
//
//  Created by Andrew Ervin Gierke on 4/8/17.
//  Copyright © 2017 Androoo. All rights reserved.
//

import UIKit

protocol UserNameLabelCellTappedDelegate {
    func moreButtonTapped(_ sender: TopTableViewCell)
}

class TopTableViewCell: UITableViewCell {
    
    //MARK: - Properties
    
    var user: User?
    
    var delegate: UserNameLabelCellTappedDelegate?
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        updateViews()
    }
    
    func updateViews() {
    }
    
    @IBAction func moreButtonTapped(_ sender: Any) {
        delegate?.moreButtonTapped(self)
    }
    
    //MARK: - Message Recieved Cell Delegate
    
    
    

}
