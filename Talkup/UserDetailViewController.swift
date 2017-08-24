//
//  UserDetailViewController.swift
//  Talkup
//
//  Created by Andrew Ervin Gierke on 7/19/17.
//  Copyright © 2017 Androoo. All rights reserved.
//

import UIKit

class UserDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, RecieverTableViewCellDelegate, filterHeaderDelegate, ChatHeaderDelegate, UINavigationControllerDelegate {
    
    //MARK: - Properties
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var chat: Chat? {
        didSet {
            updateViews()
        }
    }
    
    var user: User?
    var isDirectChat: Bool? = false
    var messageSortSelection: MessageSort = .live
    
    lazy var customTransitioningDelegate = CustomPushTransitionController() 
    
    var messages: [Message] {
        
        switch messageSortSelection {
        case .live:
            
            return chat!.filteredMessages.sorted { return $0.timestamp.compare($1.timestamp as Date) == .orderedAscending}
        case .top:
            
            return chat!.filteredMessages.sorted { return $0.score > $1.score }
            
        }
    }
    
    @IBAction func backBarButtontapped(_ sender: Any) {
    }
    
    let barHeight: CGFloat = 65
    
    //MARK: - Outlets
    
    // input bar
    
    @IBOutlet var inputBar: UIView!
    @IBOutlet weak var inputContainerViewBottomContstaint: NSLayoutConstraint!
    @IBOutlet weak var currentUserChatBarImage: UIImageView!
    @IBOutlet weak var inputChatBarTextField: InputCustomTextField!
    @IBOutlet weak var createChatButton: UIButton!
    
    // navbar
    
    @IBOutlet weak var navBarBackArrow: UIButton!
    @IBOutlet weak var navBarMoreButton: UIButton!
    @IBOutlet weak var navBarBottomSep: UIImageView!
    @IBOutlet weak var navBarBgView: UIView!
    
    // header details
    
    @IBOutlet weak var userHeaderImage: UIImageView!
    @IBOutlet weak var headerTitleLabel: UILabel!
    @IBOutlet weak var followButton: RoundedCornerButton!
    @IBOutlet weak var headerBgCoverView: UIView!
    @IBOutlet weak var headerBottomSep: UIImageView!
    
    
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
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let shareAction = UIAlertAction(title: "Share", style: .default) { (_) in
            // share stuff
        }
        
        let blockUser = UIAlertAction(title: "Block User", style: .default) { (_) in
            // block user
        }
        
        let reportAction = UIAlertAction(title: "Report", style: .default) { (_) in
            // report abuse
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(shareAction)
        alertController.addAction(reportAction)
        alertController.addAction(blockUser)
        
        present(alertController, animated: true, completion: nil)
    }
    
    
    //MARK: - View Lifecycle 
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateViews()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 86
        tableView.rowHeight = UITableViewAutomaticDimension
        
        self.navigationController?.navigationBar.isHidden = true
        tableView.backgroundColor = .white
        navBarBgView.backgroundColor = .clear
        navBarBottomSep.backgroundColor = Colors.primaryLightGray
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        
        
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
        
        currentUserChatBarImage.image = self.user?.photo
        currentUserChatBarImage.layer.cornerRadius = currentUserChatBarImage.frame.width / 2
        currentUserChatBarImage.layer.masksToBounds = true 
        
    }
    
    //MARK: - InputBar Setup
    
    
    override var inputAccessoryView: UIView? {
        get {
            self.inputBar.frame.size.height = self.barHeight
            self.inputBar.clipsToBounds = true
            return self.inputBar
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    @IBAction func submitMessageButtonTapped(_ sender: Any) {
        guard let messageText = inputChatBarTextField.text, let chat = self.chat else { return }
        
        guard let owner = UserController.shared.currentUser else { return }
        
        ChatController.shared.addMessage(byUser: owner, toChat: chat, messageText: messageText) { (_) in
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        inputChatBarTextField.text = nil
        inputChatBarTextField.resignFirstResponder()
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
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "userHeaderCell", for: indexPath) as? UserHeaderTableViewCell, let isDirect = isDirectChat else {
                return UserHeaderTableViewCell()
            }
            
            if isDirect {
                cell.followButton.isHidden = true
                cell.editButton.isHidden = false
            } else {
                cell.followButton.isHidden = false
                cell.editButton.isHidden = true 
            }
            
            cell.user = self.user
            
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0: return UITableViewAutomaticDimension
        default: return UITableViewAutomaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    
    //MARK: - TableView header 
    
    // Filter header stuff
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        switch section {
            
        case 0:
            return nil
        default:
            guard let header = tableView.dequeueReusableCell(withIdentifier: "headerViewCell") as? FilterHeaderTableViewCell else { return FilterHeaderTableViewCell() }
            
            header.delegate = self
            
            return header
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 0
        default:
            return 50
        }
    }
    
    
    // Chat header delegate 
    
    func followButtonPressed(_ sender: ChatHeaderTableViewCell) {
        
    }
    
    // Filter Header Delegate 
    
    func nowSortButtonClicked(selected: Bool, filterHeader: FilterHeaderTableViewCell) {
        
    }
    
    func topSortButtonClicked(selected: Bool, filterHeader: FilterHeaderTableViewCell) {
        
    }
    
    // Recienver Cell Delegate 
    
    func usernameClicked(user: User) {
        
    }
    
    func toggleVoteCount(_ sender: RecieverTableViewCell) {
        
    }
    
    func reportAbuse(_ sender: RecieverTableViewCell) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toEditProfile" {
            guard let destination = segue.destination as? EditProfileViewController else { return }
            destination.user = self.user
        } else if segue.identifier == "toTopicsList" {
            
            guard let destination = segue.destination as? ChatTopicsListViewController else { return }
            destination.user = self.user
            
            let backItem = UIBarButtonItem()
            backItem.title = ""
            navigationItem.backBarButtonItem = backItem
            
            let navigationController = segue.destination
            navigationController.transitioningDelegate = customTransitioningDelegate
            navigationController.modalPresentationStyle = .custom
        }
    }
    
}
