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
    @IBOutlet weak var nowBottomBorderImageView: UIImageView!
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var topBottomBorderImageView: UIImageView!
    
    var delegate: filterHeaderDelegate?
    var isLive: Bool? = true
    
    //MARK: - UI Actions
    
    @IBAction func nowButtonWasTapped(_ sender: Any) {
        delegate?.nowSortButtonClicked(selected: true, filterHeader: self)
        isLive = true
        nowLabel.textColor = Colors.flatYellow
        topLabel.textColor = Colors.primaryDarkGray
        nowBottomBorderImageView.backgroundColor = Colors.flatYellow
        topBottomBorderImageView.backgroundColor = Colors.primaryLightGray
    }
    
    @IBAction func topButtonWasTapped(_ sender: Any) {
        delegate?.topSortButtonClicked()
        isLive = false
        topLabel.textColor = Colors.greenBlue
        nowLabel.textColor = Colors.primaryDarkGray
        topBottomBorderImageView.backgroundColor = Colors.greenBlue
        nowBottomBorderImageView.backgroundColor = Colors.primaryLightGray
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        if self.isLive! {
            nowBottomBorderImageView.backgroundColor = Colors.alertOrange
            topBottomBorderImageView.backgroundColor = Colors.primaryLightGray
            nowLabel.textColor = Colors.flatYellow
            topLabel.textColor = Colors.primaryLightGray
        } else {
            nowBottomBorderImageView.backgroundColor = Colors.primaryLightGray
            topBottomBorderImageView.backgroundColor = Colors.greenBlue
            topLabel.textColor = Colors.greenBlue
            nowLabel.textColor = Colors.primaryLightGray
        }
        
    }

}
