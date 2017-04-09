//
//  UserViewController.swift
//  Talkup
//
//  Created by Andrew Ervin Gierke on 4/5/17.
//  Copyright © 2017 Androoo. All rights reserved.
//

import UIKit

class UserViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    //MARK: - Outlets
    
    @IBOutlet weak var backArrowTapped: UIButton!
    
    @IBOutlet weak var titleTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var headerHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var coverImageView: UIImageView!
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var blurCoverImageView: UIImageView!
    
    @IBOutlet weak var coverImageViewBig: UIView!
    @IBOutlet weak var topNavBarSmall: UIView!
    
    
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet weak var userAvatarImageView: UIImageView!
    
    
    @IBAction func backArrowTapped(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }

    //MARK: - Properties
    
    let maxHeaderHeight: CGFloat = 250
    let minHeaderHeight: CGFloat = 94
    
    var previousScrollOffset: CGFloat = 0
    
    var user: User?
    
    //MARK: - View Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.headerHeightConstraint.constant = maxHeaderHeight
        updateHeader()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = blurCoverImageView.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurCoverImageView.addSubview(blurEffectView)
        
        self.navigationController?.navigationBar.isHidden = true
        
        tableView.backgroundColor = .clear
        
        updateViews()
    }
    
    //MARK: - Tableview Datasource 
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 1
        case 1: return 1
        case 2: return 40 
        default: return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "topCell", for: indexPath) as? TopTableViewCell else { return TopTableViewCell() }
            
            cell.backgroundColor = .white
            
            cell.usernameLabel.text = user?.userName
            
            cell.separatorInset.left = 0
            cell.separatorInset.right = 0
            
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "labelCell", for: indexPath) as? LabelTableViewCell else { return LabelTableViewCell() }
            
            cell.separatorInset.left = 22.0
            
            cell.titleLabel.text = "Chats"
            
            return cell
        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "chatItemCell", for: indexPath) as? ChatItemTableViewCell else { return ChatItemTableViewCell() }
            
            cell.separatorInset.left = 86.0
            
            return cell
            
        default:
            let cell = UITableViewCell()
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0: return 76
        case 1: return UITableViewAutomaticDimension
        case 2: return UITableViewAutomaticDimension
        default: return 86
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let maskPathTop = UIBezierPath(roundedRect: cell.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 13.0, height: 13.0))
        let shapeLayerTop = CAShapeLayer()
        shapeLayerTop.frame = cell.bounds
        shapeLayerTop.path = maskPathTop.cgPath
        
        switch indexPath.section {
            
        case 0:
            return cell.layer.mask = shapeLayerTop
        default:
            break
        }
        
        
    }
    
    //MARK: - Navigation bar animation
    
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let scrollDiff = scrollView.contentOffset.y - self.previousScrollOffset
        
        let absoluteTop: CGFloat = 0;
        let absoluteBottom: CGFloat = scrollView.contentSize.height - scrollView.frame.size.height;
        
        let isScrollingDown = scrollDiff > 0 && scrollView.contentOffset.y > absoluteTop
        let isScrollingUp = scrollDiff < 0 && scrollView.contentOffset.y < absoluteBottom
        
        if canAnimateHeader(scrollView) {
            
            // Calculate new header height
            var newHeight = self.headerHeightConstraint.constant
            if isScrollingDown {
                newHeight = max(self.minHeaderHeight, self.headerHeightConstraint.constant - abs(scrollDiff))
            } else if isScrollingUp {
                newHeight = min(self.maxHeaderHeight, self.headerHeightConstraint.constant + abs(scrollDiff))
            }
            
            // Header needs to animate
            if newHeight != self.headerHeightConstraint.constant {
                self.headerHeightConstraint.constant = newHeight
                self.updateHeader()
                self.setScrollPosition(self.previousScrollOffset)
            }
            
            self.previousScrollOffset = scrollView.contentOffset.y
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.scrollViewDidStopScrolling()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            self.scrollViewDidStopScrolling()
        }
    }
    
    func scrollViewDidStopScrolling() {
        let range = self.maxHeaderHeight - self.minHeaderHeight
        let midPoint = self.minHeaderHeight + (range / 2)
        
        if self.headerHeightConstraint.constant > midPoint {
            self.expandHeader()
        } else {
            self.collapseHeader()
        }
    }
    
    func canAnimateHeader(_ scrollView: UIScrollView) -> Bool {
        // Calculate the size of the scrollView when header is collapsed
        let scrollViewMaxHeight = scrollView.frame.height + self.headerHeightConstraint.constant - minHeaderHeight
        
        // Make sure that when header is collapsed, there is still room to scroll
        return scrollView.contentSize.height > scrollViewMaxHeight
    }
    
    func collapseHeader() {
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.2, animations: {
            self.headerHeightConstraint.constant = self.minHeaderHeight
            self.updateHeader()
            self.view.layoutIfNeeded()
        })
    }
    
    func expandHeader() {
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.2, animations: {
            self.headerHeightConstraint.constant = self.maxHeaderHeight
            self.updateHeader()
            self.view.layoutIfNeeded()
        })
    }
    
    func setScrollPosition(_ position: CGFloat) {
        self.tableView.contentOffset = CGPoint(x: self.tableView.contentOffset.x, y: position)
    }
    
    func updateHeader() {
        let range = self.maxHeaderHeight - self.minHeaderHeight
        let openAmount = self.headerHeightConstraint.constant - self.minHeaderHeight
        let percentage = openAmount / range
        
        self.blurCoverImageView.alpha = 1 - percentage
        self.titleTopConstraint.constant = -openAmount + 35
    }
    
    
    func updateViews() {
        
        coverImageView.image = user?.photo
        blurCoverImageView.image = user?.photo
        
        usernameLabel.text = user?.userName
        
        let layer = CAGradientLayer()
//        layer.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: imageOverlayImageView.frame.height)
        layer.colors = [UIColor.clear.cgColor, Colors.clearBlack.cgColor]
//        imageOverlayImageView.layer.addSublayer(layer)

        
    }

}












