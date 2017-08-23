//
//  ChatViewController.swift
//  Talkup
//
//  Created by Andrew Ervin Gierke on 4/3/17.
//  Copyright © 2017 Androoo. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, RecieverTableViewCellDelegate, filterHeaderDelegate, ChatHeaderDelegate, UINavigationControllerDelegate {

    //MARK: - Outlets
    
    @IBOutlet weak var navBarViewBgView: UIView!
    @IBOutlet weak var sendMessageButtonTapped: UIButton!
    @IBOutlet weak var chatTitleLabel: UILabel!
    @IBOutlet weak var mainNavBottomSep: UIImageView!
    
    
    //MARK: - Properties
    @IBOutlet var tableView: UITableView!
    
    var followButton: FollowingButton?
    
    var chat: Chat? {
        didSet {
//            updateViews()
        }
    }
    
    var message: Message? {
        didSet {
            
        }
    }
    
    lazy var customTransitioningDelegate = CustomPushTransitionController()
    var heroChatCell: ChatHeaderTableViewCell?
    
    var messageSortSelection: MessageSort = .live
    
    var timeOfLastVisit: Date?
    
    
    //MARK: - UIActions

    @IBAction func messageTextFieldEditingChanged(_ sender: Any) {
        guard inputTextField.text != "" else { sendMessageButtonTapped.isEnabled = false; return }
        sendMessageButtonTapped.isEnabled = true
        
    }
    
    
    var messages: [Message] {
        
        switch MessageController.shared.messagesFilterState {
            
        case .live:
            return chat!.filteredMessages.sorted { return $0.timestamp.compare($1.timestamp as Date) == .orderedAscending}
        case .top:
            return chat!.filteredMessages.sorted { return $0.score > $1.score }
            
        }
    }
    
    private func updateViews() {
        
        guard let chat = chat, isViewLoaded else { return }
        
        let group = DispatchGroup()
        
        group.enter()
        
        MessageController.shared.fetchMessagesIn(chat: chat) {
            group.enter()
            MessageController.shared.fetchMessageOwnersFor(messages: chat.messages) {
                
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
        
        ChatController.shared.checkSubscriptionTo(chat: chat) { (subscription) in
            if subscription {
                self.followButton = .pressed
                
            } else {
                self.followButton = .notPressed
            }
        }
        
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
    }
    
    
    //MARK: - View lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        updateViews()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        sendMessageButtonTapped.isEnabled = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = true
        tableView.backgroundColor = .white
        navBarViewBgView.backgroundColor = .white
        mainNavBottomSep.backgroundColor = Colors.primaryLightGray
        
        guard let name = chat?.topic else { return }
        inputTextField.delegate = self
        updateViews()
        customize()
        
        guard let chat = chat, isViewLoaded else { return }
        title = "\(chat.topic)"
        
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(chatMessagesChanged(_:)), name: ChatController.ChatMessagesChangedNotification, object: nil)
        
        tableView.estimatedRowHeight = 86
        tableView.rowHeight = UITableViewAutomaticDimension
        
        
    }
    
    // set timeOfLastVisit property to now
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        //set value of current date to key of chat's recordID.recordName in user defaults
        
        guard let recordName = chat?.cloudKitRecordID?.recordName else { return }
        
        let defaults = UserDefaults.standard

        defaults.set(Date(), forKey: "\(recordName)")
        
        chat?.unreadMessages = []
        
    }
    
    // MARK: Notifications
    
    func chatMessagesChanged(_ notification: Notification) {

        tableView.reloadData()
        
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0: return 1
        default: return chat?.filteredMessages.count ?? 0
            
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if indexPath.section != 0 {
            if tableView.isDragging {
                cell.transform = CGAffineTransform.init(scaleX: 0.5, y: 0.5)
                UIView.animate(withDuration: 0.3, animations: {
                    cell.transform = CGAffineTransform.identity
                })
            }
        }
    }
    
    
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
    
    
    // set up the cells 
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "headerCell", for: indexPath) as? ChatHeaderTableViewCell else { return ChatHeaderTableViewCell() }
            
            cell.chat = chat
            cell.backgroundColor = Colors.primaryLightGray
            cell.following = followButton
            cell.delegate = self
            self.heroChatCell = cell
            
            return cell
            
        default:
            
            
            let message = messages[indexPath.row]
            
            guard let owner = message.owner, let currentUser = UserController.shared.currentUser else { return  UITableViewCell() }
            
            
            if owner.cloudKitRecordID == currentUser.cloudKitRecordID {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "senderCell", for: indexPath) as? SenderTableViewCell else { return SenderTableViewCell() }
                
                cell.message = message
                
                cell.backgroundColor = .clear
                
                return cell
                
            } else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "recieverCell", for: indexPath) as? RecieverTableViewCell else { return RecieverTableViewCell() }
                
                cell.backgroundColor = .clear
                
                cell.delegate = self
                cell.message = message
                
                return cell
                
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if inputTextField.isFirstResponder { inputTextField.resignFirstResponder() }
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
    
    
    //MARK: - Customize Appearance
    
    func customize() {
        
        //        self.tableView.estimatedRowHeight = self.barHeight
        self.tableView.contentInset.bottom = self.barHeight
        self.tableView.scrollIndicatorInsets.bottom = self.barHeight
        
        self.currentUserAvatarInputImageView.image = UserController.shared.currentUser?.photo
        self.currentUserAvatarInputImageView.layer.cornerRadius = currentUserAvatarInputImageView.layer.frame.width / 2
        self.currentUserAvatarInputImageView.layer.masksToBounds = true 
    }
    
    
    //MARK: - Chat Input
    
    @IBAction func submitChatMessageButtonTapped(_ sender: Any) {
        guard let messageText = inputTextField.text, let chat = self.chat else { return }
        
        guard let owner = UserController.shared.currentUser else { return }
        
        ChatController.shared.addMessage(byUser: owner, toChat: chat, messageText: messageText) { (_) in
            DispatchQueue.main.async {
                
                self.tableView.reloadData()
            }
        }
        inputTextField.text = nil
        inputTextField.resignFirstResponder()
    }
    
    
    @IBAction func backNavButtonTapped(_ sender: Any) {
        
        if chat?.isDismisable == true {
            chat?.isDismisable = false
            
            performSegue(withIdentifier: "unwindToHome", sender: self)
            
        } else {
            
            _ = navigationController?.popViewController(animated: true)
            inputBar.isHidden = true
            
        }
    }
    
    
    @IBOutlet var inputBar: UIView!
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var currentUserAvatarInputImageView: UIImageView!
    
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
    
    let barHeight: CGFloat = 65
    
    //MARK: - Scrolling UX
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        guard let name = chat?.topic else { return }
        
        if let heroCell = self.heroChatCell {
            if scrollView.contentOffset.y < 0 {
                heroCell.headerViewTopContstraint.constant = scrollView.contentOffset.y
            }
        }
        
        if (scrollView.contentOffset.y > 0) && (scrollView.contentOffset.y < 350) {
            
            title = ""
            
            title = "\(name)"
            chatTitleLabel.text = "\(name)"
            chatTitleLabel.textColor = Colors.primaryBgPurple
            chatTitleLabel.font = UIFont(name: "ArialRoundedMTBold", size: 20)
            
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
    
    
    // Confirm Alert
    
    func confirmBlockAlert() {
        let confirmAlertController = UIAlertController(title: "Block User?", message: "Are you suer you want to block this user?", preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "Confirm", style: .default) { (action) in
            // block action here
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        confirmAlertController.addAction(confirmAction)
        confirmAlertController.addAction(cancelAction)
        present(confirmAlertController, animated: true, completion: nil)
    }
    
    //MARK: - Filter Header Delegate 
    
    func nowSortButtonClicked(selected: Bool, filterHeader: FilterHeaderTableViewCell) {
        messageSortSelection = .live
        MessageController.shared.messagesFilterState = .live
        filterHeader.isLive = true
        updateViews()
    }
    
    func topSortButtonClicked(selected: Bool, filterHeader: FilterHeaderTableViewCell) {
        messageSortSelection = .top
        MessageController.shared.messagesFilterState = .top
        filterHeader.isLive = false 
        updateViews()
    }
    
    //MARK: - Chat Header Delegate 
    
    func followButtonPressed(_ sender: ChatHeaderTableViewCell) {
        
        guard let chat = chat,
            let user = UserController.shared.currentUser else { return }
        
        ChatController.shared.followMessagesIn(chat: chat)
        
        if followButton == .pressed {
            // remove chat from followed list
            followButton = .notPressed
        } else {
            UserController.shared.followChat(Foruser: user, chat: chat)
            followButton = .pressed
        }
        
        ChatController.shared.toggleSubscriptionTo(chatNammed: chat) { (_, _, _) in
            
            DispatchQueue.main.async {
                self.updateViews()
            }
        }
    }
    
    //MARK: - Message Recieved Cell Delegate
    
    func reportAbuse(_ sender: RecieverTableViewCell) {
        
        guard let indexPath = self.tableView.indexPath(for: sender),
            let message = chat?.messages[indexPath.row],
            let owner = message.owner,
            let user = UserController.shared.currentUser else { return }
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let reportAbuse = UIAlertAction(title: "Report", style: .default) { (action) in
            print("report abuse")
        }
        
        let blockUser = UIAlertAction(title: "Block", style: .destructive) { (action) in
            
            guard let userName = message.owner?.userName else { return }
            
            let confirmAlertController = UIAlertController(title: "Block User?", message: "Are you suer you want to block \(userName)?", preferredStyle: .alert)
            
            let confirmAction = UIAlertAction(title: "Block", style: .default) { (action) in
                UserController.shared.addBlockedUser(Foruser: user, blockedUser: owner, completion: {
                    
                    //remove blocked content is in update views
                    //set cell to hidden
                    
                    self.updateViews()
                    
                })
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            confirmAlertController.addAction(confirmAction)
            confirmAlertController.addAction(cancelAction)
            self.present(confirmAlertController, animated: true, completion: nil)
            
            
        }
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(reportAbuse)
        alertController.addAction(blockUser)
        alertController.addAction(cancelButton)
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    func toggleVoteCount(_ sender: RecieverTableViewCell) {
        
        guard let message = sender.message else { return }
        
        // update subscription and score
        
        if !tableView.isDragging {
            
            MessageController.shared.toggleSubscriptionTo(messageNamed: message) { (_, _, _) in
                MessageController.shared.updateMessageScore(forMessage: message) {
                    
                    DispatchQueue.main.async {
                        self.updateViews()
                        sender.voteButton.isEnabled = true
                    }
                }
            }
        }
    }
    
    // send the user to the User Detail
    
    var user: User?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toUserDetail" {
            guard let user = self.user
                else { return }
            
            var directChat: Chat?
            
            ChatController.shared.fetchDirectChat(forUser: user, completion: { (chat) in
                directChat = chat
            })
            
            if let destinationViewController = segue.destination as? UserDetailViewController {
                
                destinationViewController.user = user
                destinationViewController.chat = directChat
                destinationViewController.isDirectChat = false
                
                let backItem = UIBarButtonItem()
                backItem.title = ""
                navigationItem.backBarButtonItem = backItem
                
                let navigationController = segue.destination
                navigationController.transitioningDelegate = customTransitioningDelegate
                navigationController.modalPresentationStyle = .custom
                
            }
        }
    }
    
    func usernameClicked(user: User) {
        
        self.user = user
        self.performSegue(withIdentifier: "toUserDetail", sender: nil)
        
    }
}



