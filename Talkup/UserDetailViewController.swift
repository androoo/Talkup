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
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var chat: Chat? {
        didSet {
            updateViews()
        }
    }
    
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
    
    
    //MARK: - View Lifecycle 
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateViews()
    }

    //MARK: - View Helpers 
    
    func updateViews() {
        guard let chat = chat, isViewLoaded else { return }
        
        let group = DispatchGroup()
        
        group.enter()
        
        MessageController.shared.fetchMessagesIn(chat: chat) {
            group.enter()
            MessageController.shared.fetchMessageOwnersFor(messages: chat.messages) {
                
                //check to see if any messages need to be hidden
                self.hideBlockedMessages()
                
                group.leave()
            }
            group.leave()
        }
        group.notify(queue: DispatchQueue.main) {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    // Remove Blocked Message
    
    func hideBlockedMessages() {
        
        guard let messages = chat?.messages else { return }
        
        guard let blockedUsers = UserController.shared.currentUser?.blocked else { return }
        
        // the recordNames of the blocked users and owner refs are what will match
        let blockedRecordNames = blockedUsers.flatMap({$0.recordID.recordName})
        
        //if message owner ref == blocked owner ref then message is hidden
        let messageRecordNames = messages.flatMap({$0.ownerReference.recordID.recordName})
        
        for id in messageRecordNames {
            if blockedRecordNames.contains(id) {
                print("\(id) is hidden")
                
                for message in messages {
                    if message.ownerReference.recordID.recordName == id {
                        message.blocked = true
                    }
                }
            }
        }
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
