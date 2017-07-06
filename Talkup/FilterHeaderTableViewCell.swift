//
//  FilterHeaderTableViewCell.swift
//  Talkup
//
//  Created by Andrew Ervin Gierke on 7/5/17.
//  Copyright © 2017 Androoo. All rights reserved.
//

import UIKit

protocol filterHeaderDelegate {
    func nowSortButtonClicked(selected: Bool, filterHeader: FilterHeaderTableViewCell)
    func topSortButtonClicked() 
}

class FilterHeaderTableViewCell: UITableViewCell {
    
    //MARK: - Properties 
    
    @IBOutlet weak var nowLabel: UILabel!
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var nowBottomBorderImageView: UIImageView!
    @IBOutlet weak var topBottomBorderImageView: UIImageView!
    
    var delegate: filterHeaderDelegate?
    
    //MARK: - UI Actions
    
    @IBAction func nowButtonWasTapped(_ sender: Any) {
        print("now clicked")
        delegate?.nowSortButtonClicked(selected: true, filterHeader: self)
    }
    
    @IBAction func topButtonWasTapped(_ sender: Any) {
        delegate?.topSortButtonClicked()
        print("top clicked")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        nowBottomBorderImageView.backgroundColor = Colors.alertOrange
        topBottomBorderImageView.backgroundColor = Colors.bubbleGray
        nowLabel.textColor = Colors.alertOrange
        
    }
    

}
