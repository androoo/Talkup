//
//  ChatDetailTableViewController.swift
//  Talkup
//
//  Created by Andrew Ervin Gierke on 3/13/17.
//  Copyright © 2017 Androoo. All rights reserved.
//

import UIKit

class ChatDetailTableViewController: UITableViewController, UITextFieldDelegate, MessageVoteButtonDelegate {
    
    //MARK: - Outlets
    
    @IBOutlet weak var liveButton: UIButton!
    @IBOutlet weak var topButton: UIButton!
    
    @IBOutlet weak var liveButtonBottomBorder: UIImageView!
    @IBOutlet weak var topButtonBottomBorder: UIImageView!
    
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
        
        liveButton.setTitleColor(Colors.rose, for: .normal)
        topButton.setTitleColor(.lightGray, for: .normal)
        liveButtonBottomBorder.isHidden = false
        liveButtonBottomBorder.backgroundColor = Colors.rose
        topButtonBottomBorder.isHidden = true
        messageSortSelection = .live
        updateViews()
    }
    
    @IBAction func topButtonTapped(_ sender: Any) {
        
        liveButton.setTitleColor(.lightGray, for: .normal)
        topButton.setTitleColor(Colors.rose, for: .normal)
        liveButtonBottomBorder.isHidden = true
        topButtonBottomBorder.backgroundColor = Colors.rose
        topButtonBottomBorder.isHidden = false
        messageSortSelection = .top
        updateViews()
    }
    
    var messages: [Message] {
        
        switch messageSortSelection {
        case .live:
            
            return chat!.messages.sorted { return $0.timestamp.compare($1.timestamp as Date) == .orderedDescending}
        case .top:
            
            return chat!.messages.sorted { return $0.score > $1.score }
            
        }
    }
    
    
    private func updateViews() {
        //do stuff to stuff
        guard let chat = chat, isViewLoaded else { return }
        
        MessageController.shared.fetchMessagesIn(chat: chat) {
            MessageController.shared.fetchMessageOwnersFor(messages: chat.messages) {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
        
        
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        
        tableView.reloadData()
        
    }
    //MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateViews()
        customize()
        
        
        liveButtonBottomBorder.isHidden = false
        
        guard let chat = chat, isViewLoaded else { return }
        //        title = "\(chat.topic)"
        self.navigationItem.titleView = setTitle(title: "\(chat.topic)", subtitle: "45 people")
        
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(chatMessagesChanged(_:)), name: ChatController.ChatMessagesChangedNotification, object: nil)
        
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    // MARK: Notifications
    
    func chatMessagesChanged(_ notification: Notification) {
        guard let notificationChat = notification.object as? Chat,
            let chat = chat, notificationChat === chat else { return } // Not our post
        updateViews()
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chat?.messages.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // switch on the message's owner. If the owner ID = current user ID then cell type is sender.
        let currentUser = UserController.shared.currentUser
        
        let message = messages[indexPath.row]
        
        if message.owner?.cloudKitRecordID == currentUser?.cloudKitRecordID {
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
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 86
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if inputTextField.isFirstResponder { inputTextField.resignFirstResponder() }
    }
    
    //MARK: - Customize Appearance
    
    func customize() {
        self.tableView.estimatedRowHeight = self.barHeight
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.contentInset.bottom = self.barHeight
        self.tableView.scrollIndicatorInsets.bottom = self.barHeight
    }
    
    //MARK: - Chat Input
    
    @IBAction func sendChatMessageButtonTapped(_ sender: Any) {
        guard let messageText = inputTextField.text, let chat = self.chat else { return }
        
        // need to update the addMessage init to User as owner param
        guard let owner = UserController.shared.currentUser else { return }
        
        ChatController.shared.addMessage(byUser: owner ,toChat: chat, messageText: messageText)
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
    
    //MARK: - Message Cell Delegate
    
    func toggleVoteCount(_ sender: RecieverTableViewCell) {
        
        guard let message = sender.message else { return }
        
        MessageController.shared.toggleSubscriptionTo(messageNamed: message) { (_, _, _) in
            MessageController.shared.updateMessageScore(forMessage: message) {
                
                DispatchQueue.main.async {
                    self.updateViews()
                    
                }
            }
        }
    }
}



















