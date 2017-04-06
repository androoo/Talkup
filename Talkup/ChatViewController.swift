//
//  ChatViewController.swift
//  Talkup
//
//  Created by Andrew Ervin Gierke on 4/3/17.
//  Copyright © 2017 Androoo. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, RecieverTableViewCellDelegate {

    //MARK: - Outlets
    
    @IBOutlet weak var liveButton: UIButton!
    @IBOutlet weak var topButton: UIButton!
    
    @IBOutlet weak var liveButtonBottomBorder: UIImageView!
    @IBOutlet weak var topButtonBottomBorder: UIImageView!
    @IBOutlet weak var navBarBottomBorderImageView: UIImageView!
    
    @IBOutlet weak var sendMessageButtonTapped: UIButton!
    
    @IBOutlet weak var chatTitleLabel: UILabel!
    
    //MARK: - Properties
    @IBOutlet var tableView: UITableView!
    
    var chat: Chat? {
        didSet {
            updateViews()
        }
    }
    
    var message: Message? {
        didSet {
        }
    }
    
    var messageSortSelection: MessageSort = .live
    
    //MARK: - UIActions
    
    @IBAction func liveButton(_ sender: Any) {
        liveButton.setTitleColor(Colors.magenta, for: .normal)
        topButton.setTitleColor(.lightGray, for: .normal)
        liveButtonBottomBorder.backgroundColor = Colors.magenta
        topButtonBottomBorder.backgroundColor = Colors.bubbleGray
        messageSortSelection = .live
        updateViews()
    }

    @IBAction func topButton(_ sender: Any) {
        liveButton.setTitleColor(.lightGray, for: .normal)
        topButton.setTitleColor(Colors.magenta, for: .normal)
        topButtonBottomBorder.backgroundColor = Colors.magenta
        liveButtonBottomBorder.backgroundColor = Colors.bubbleGray
        messageSortSelection = .top
        updateViews()
    }

    @IBAction func messageTextFieldEditingChanged(_ sender: Any) {
        guard inputTextField.text != "" else { sendMessageButtonTapped.isEnabled = false; return }
        sendMessageButtonTapped.isEnabled = true
        
    }
    
    
    var messages: [Message] {
        
        switch messageSortSelection {
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
        
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
    }
    
    //MARK: - View lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        liveButton.setTitleColor(Colors.magenta, for: .normal)
        liveButtonBottomBorder.backgroundColor = Colors.magenta
        topButtonBottomBorder.backgroundColor = Colors.bubbleGray
        
        updateViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        sendMessageButtonTapped.isEnabled = false
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let name = chat?.topic else { return }
        inputTextField.delegate = self
        updateViews()
        customize()
        navBarBottomBorderImageView.backgroundColor = Colors.bubbleGray
        liveButtonBottomBorder.isHidden = false
        title = "\(name)"
        chatTitleLabel.text = "\(name)"
        
        guard let chat = chat, isViewLoaded else { return }
        title = "\(chat.topic)"
        
        //        self.navigationItem.titleView = setTitle(title: "\(chat.topic)", subtitle: "45 people")
        
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(chatMessagesChanged(_:)), name: ChatController.ChatMessagesChangedNotification, object: nil)
        
        tableView.estimatedRowHeight = 86
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    // MARK: Notifications
    
    func chatMessagesChanged(_ notification: Notification) {

        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chat?.filteredMessages.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if tableView.isDragging {
            cell.transform = CGAffineTransform.init(scaleX: 0.5, y: 0.5)
            UIView.animate(withDuration: 0.3, animations: {
                cell.transform = CGAffineTransform.identity
            })
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // switch on the message's owner. If the owner ID = current user ID then cell type is sender.
        
        let message = messages[indexPath.row]
        
        guard let owner = message.owner, let currentUser = UserController.shared.currentUser else { return  UITableViewCell() }
        
        if owner.cloudKitRecordID == currentUser.cloudKitRecordID {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "senderCell", for: indexPath) as? SenderTableViewCell else { return SenderTableViewCell() }
            
            cell.message = message
            return cell
            
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "recieverCell", for: indexPath) as? RecieverTableViewCell else { return RecieverTableViewCell() }
            
            cell.delegate = self
            cell.message = message
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if inputTextField.isFirstResponder { inputTextField.resignFirstResponder() }
    }
    
    
    //MARK: - Customize Appearance
    
    func customize() {
        
        //        self.tableView.estimatedRowHeight = self.barHeight
        self.tableView.contentInset.bottom = self.barHeight
        self.tableView.scrollIndicatorInsets.bottom = self.barHeight
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
        _ = navigationController?.popViewController(animated: true)
        inputBar.isHidden = true 
    }
    
    
    @IBOutlet var inputBar: UIView!
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
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
    
    let barHeight: CGFloat = 50
    
    //MARK: - Helper Methods
    
    
    
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
    
    func usernameClicked(user: User) {
        
        self.performSegue(withIdentifier: "toUserDetail", sender: user)
    
    }
}

