//
//  ChatDetailTableViewController.swift
//  Talkup
//
//  Created by Andrew Ervin Gierke on 3/13/17.
//  Copyright © 2017 Androoo. All rights reserved.
//

import UIKit

class ChatDetailTableViewController: UITableViewController, UITextFieldDelegate, RecieverTableViewCellDelegate {
    
    //MARK: - Outlets
    
    @IBOutlet weak var liveButton: UIButton!
    @IBOutlet weak var topButton: UIButton!
    
    @IBOutlet weak var liveButtonBottomBorder: UIImageView!
    @IBOutlet weak var topButtonBottomBorder: UIImageView!
    
    @IBOutlet weak var sendMessageButtonTapped: UIButton!
    
    
    //MARK: - Properties
    
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
    
    
    @IBAction func liveButtonTapped(_ sender: Any) {
        
        liveButton.setTitleColor(Colors.magenta, for: .normal)
        topButton.setTitleColor(.lightGray, for: .normal)
        liveButtonBottomBorder.isHidden = false
        liveButtonBottomBorder.backgroundColor = Colors.magenta
        topButtonBottomBorder.isHidden = true
        messageSortSelection = .live
        updateViews()
        
    }
    
    @IBAction func topButtonTapped(_ sender: Any) {
        
        liveButton.setTitleColor(.lightGray, for: .normal)
        topButton.setTitleColor(Colors.magenta, for: .normal)
        liveButtonBottomBorder.isHidden = true
        topButtonBottomBorder.backgroundColor = Colors.magenta
        topButtonBottomBorder.isHidden = false
        messageSortSelection = .top
        updateViews()
    }
    
    @IBAction func typeMessageTextFieldEditingChanged(_ sender: Any) {
        guard inputTextField.text != "" else { sendMessageButtonTapped.isEnabled = false; return }
        sendMessageButtonTapped.isEnabled = true
    }
    
    
    var messages: [Message] {
        
        switch messageSortSelection {
        case .live:
            
            return chat!.messages.sorted { return $0.timestamp.compare($1.timestamp as Date) == .orderedAscending}
        case .top:
            
            return chat!.messages.sorted { return $0.score > $1.score }
            
        }
    }
    
    private func updateViews() {
        guard let chat = chat, isViewLoaded else { return }
        
        let group = DispatchGroup()
        
        group.enter()
        MessageController.shared.fetchMessagesIn(chat: chat) {
            group.enter()
            MessageController.shared.fetchMessageOwnersFor(messages: chat.messages) {
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
        
        liveButtonBottomBorder.isHidden = false
        liveButton.setTitleColor(Colors.magenta, for: .normal)
        liveButtonBottomBorder.backgroundColor = Colors.magenta
        
        updateViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        sendMessageButtonTapped.isEnabled = false
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        inputTextField.delegate = self
        
        updateViews()
        customize()
        
        liveButtonBottomBorder.isHidden = false
        
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
        //        guard let notificationChat = notification.object as? Chat,
        //            let chat = chat, notificationChat === chat else { return } // Not our post
        //        updateViews()
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chat?.messages.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if tableView.isDragging {
            cell.transform = CGAffineTransform.init(scaleX: 0.5, y: 0.5)
            UIView.animate(withDuration: 0.3, animations: {
                cell.transform = CGAffineTransform.identity
            })
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if inputTextField.isFirstResponder { inputTextField.resignFirstResponder() }
    }
    
    
    //MARK: - Customize Appearance
    
    func customize() {
        
        //        self.tableView.estimatedRowHeight = self.barHeight
        self.tableView.contentInset.bottom = self.barHeight
        self.tableView.scrollIndicatorInsets.bottom = self.barHeight
    }
    
    //MARK: - Chat Input
    
    @IBAction func sendChatMessageButtonTapped(_ sender: Any) {
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
    
    func setTitle(title:String, subtitle:String) -> UIView {
        let titleLabel = UILabel(frame: CGRect(x: 0, y: -2, width: 0, height: 0))
        
        titleLabel.backgroundColor = UIColor.clear
        titleLabel.textColor = UIColor.black
        titleLabel.font = UIFont.boldSystemFont(ofSize: 17)
        titleLabel.text = title
        titleLabel.sizeToFit()
        
        let subtitleLabel = UILabel(frame: CGRect(x: 0, y: 18, width: 0, height: 0))
        subtitleLabel.backgroundColor = UIColor.clear
        subtitleLabel.textColor = UIColor.lightGray
        subtitleLabel.font = UIFont.systemFont(ofSize: 12)
        subtitleLabel.text = subtitle
        subtitleLabel.sizeToFit()
        
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: max(titleLabel.frame.size.width, subtitleLabel.frame.size.width), height: 30))
        titleView.addSubview(titleLabel)
        titleView.addSubview(subtitleLabel)
        
        let widthDiff = subtitleLabel.frame.size.width - titleLabel.frame.size.width
        
        if widthDiff < 0 {
            let newX = widthDiff / 2
            subtitleLabel.frame.origin.x = abs(newX)
        } else {
            let newX = widthDiff / 2
            titleLabel.frame.origin.x = newX
        }
        
        return titleView
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
    
    //MARK: - Message Cell Delegate
    
    func reportAbuse(_ sender: RecieverTableViewCell) {
        
        guard let indexPath = self.tableView.indexPath(for: sender),
            let message = chat?.messages[indexPath.row],
            let owner = message.owner,
            let user = UserController.shared.currentUser else { return }

        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let reportAbuse = UIAlertAction(title: "Report", style: .default) { (action) in
            print("report abuse")
        }
        
        let blockUser = UIAlertAction(title: "Block", style: .default) { (action) in
            
            guard let userName = message.owner?.userName else { return }
            
            let confirmAlertController = UIAlertController(title: "Block User?", message: "Are you suer you want to block \(userName)?", preferredStyle: .alert)
            
            let confirmAction = UIAlertAction(title: "Block", style: .default) { (action) in
                UserController.shared.addBlockedUser(Foruser: user, blockedUser: owner, completion: {
                    // remove blockd user's content from users feed
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
}



















