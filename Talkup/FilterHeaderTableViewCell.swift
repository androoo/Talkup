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
    func topSortButtonClicked(selected: Bool, filterHeader: FilterHeaderTableViewCell)
}

class FilterHeaderTableViewCell: UITableViewCell {
    
    //MARK: - Properties 
    
    @IBOutlet weak var topBgView: UIView!
    @IBOutlet weak var nowBgView: UIView!
    @IBOutlet weak var nowLabel: UILabel!
    @IBOutlet weak var nowBottomBorderImageView: UIImageView!
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var topBottomBorderImageView: UIImageView!
    
    var delegate: filterHeaderDelegate?
    var isLive: Bool?
    var filterState: MessageSort? 
    
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
        delegate?.topSortButtonClicked(selected: true, filterHeader: self)
        isLive = false
        topLabel.textColor = Colors.greenBlue
        nowLabel.textColor = Colors.primaryDarkGray
        topBottomBorderImageView.backgroundColor = Colors.greenBlue
        nowBottomBorderImageView.backgroundColor = Colors.primaryLightGray
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
//        nowBgView.backgroundColor = Colors.primaryLightGray
//        topBgView.backgroundColor = Colors.primaryLightGray
        
        if MessageController.shared.messagesFilterState == .live  {
            nowBottomBorderImageView.backgroundColor = Colors.alertOrange
            topBottomBorderImageView.backgroundColor = Colors.primaryLightGray
            nowLabel.textColor = Colors.flatYellow
            topLabel.textColor = Colors.primaryDarkGray
        } else {
            nowBottomBorderImageView.backgroundColor = Colors.primaryLightGray
            topBottomBorderImageView.backgroundColor = Colors.greenBlue
            topLabel.textColor = Colors.greenBlue
            nowLabel.textColor = Colors.primaryDarkGray
            
        }
    }
}
