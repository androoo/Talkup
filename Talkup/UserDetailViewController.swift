//
//  UserDetailViewController.swift
//  Talkup
//
//  Created by Andrew Ervin Gierke on 7/19/17.
//  Copyright © 2017 Androoo. All rights reserved.
//

import UIKit

class UserDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, RecieverTableViewCellDelegate, filterHeaderDelegate, ChatHeaderDelegate {
    
    //MARK: - Properties 
    
    var chat: Chat?
    var messageSortSelection: MessageSort = .live
    
    var messages: [Message] {
        
        switch messageSortSelection {
        case .live:
            
            return chat!.filteredMessages.sorted { return $0.timestamp.compare($1.timestamp as Date) == .orderedAscending}
        case .top:
            
            return chat!.filteredMessages.sorted { return $0.score > $1.score }
            
        }
    }
    
    
    //MARK: - Outlets
    
    // input bar
    @IBOutlet weak var inputContainerViewBottomContstaint: NSLayoutConstraint!
    @IBOutlet weak var currentUserChatBarImage: UIImageView!
    @IBOutlet weak var inputChatBarTextField: InputCustomTextField!
    @IBOutlet weak var createChatButton: UIButton!
    
    // navbar
    
    @IBOutlet weak var navBarBackArrow: UIButton!
    @IBOutlet weak var navBarMoreButton: UIButton!
    
    // header details
    
    @IBOutlet weak var userHeaderImage: UIImageView!
    @IBOutlet weak var headerTitleLabel: UILabel!
    @IBOutlet weak var followButton: RoundedCornerButton!
    @IBOutlet weak var headerBgCoverView: UIView!
    
    
    //MARK: - UI Actions 
    
    @IBAction func createMessageButtonTapped(_ sender: Any) {
        
    }
    
    @IBAction func navBarBackArrowTapped(_ sender: Any) {
        
        if chat?.isDismisable == true {
            chat?.isDismisable = false
            
            performSegue(withIdentifier: "unwindToHome", sender: self)
            
        } else {
            
            _ = navigationController?.popViewController(animated: true)
            
        }
        
    }
    
    @IBAction func navBarMoreButtonTapped(_ sender: Any) {
        
    }

    
    
    //MARK: - TableView Datasource 
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0: return 1
        default: return chat?.messages.count ?? 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
            
        case 0:
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "userHeaderCell", for: indexPath) as? UserHeaderTableViewCell else { return UserHeaderTableViewCell() }
            return cell
            
        default:
            
            let message = messages[indexPath.row]
            
            guard let owner = message.owner, let currentUser = UserController.shared.currentUser else { return UITableViewCell() }
            
            if owner.cloudKitRecordID == currentUser.cloudKitRecordID {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "senderCell", for: indexPath) as? SenderTableViewCell else { return SenderTableViewCell() }
                
                cell.message = message
                cell.backgroundColor = .clear
                return cell
            } else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "recieverCell", for: indexPath) as? RecieverTableViewCell else { return RecieverTableViewCell() }
                
                cell.backgroundColor = .clear
                cell.message = message
                return cell
            }
        }
        
    }
    
    
    // Chat header delegate 
    
    func followButtonPressed(_ sender: ChatHeaderTableViewCell) {
        
    }
    
    // Filter Header Delegate 
    
    func nowSortButtonClicked(selected: Bool, filterHeader: FilterHeaderTableViewCell) {
        
    }
    
    func topSortButtonClicked() {
        
    }
    
    // Recienver Cell Delegate 
    
    func usernameClicked(user: User) {
        
    }
    
    func toggleVoteCount(_ sender: RecieverTableViewCell) {
        
    }
    
    func reportAbuse(_ sender: RecieverTableViewCell) {
        
    }
    
}
