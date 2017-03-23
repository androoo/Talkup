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
    
    
    //MARK: - Properties
    
    var chat: Chat? {
        didSet {
            updateViews()
        }
    }
    
    var messageSortSelection: MessageSort = .live
    
    //MARK: - UIActions
   
    
    
    @IBAction func liveButtonTapped(_ sender: Any) {
        
        liveButton.tintColor = UIColor.red
        topButton.tintColor = UIColor.lightGray
        print("live button tapped")
        messageSortSelection = .live
        
    }
    
    @IBAction func topButtonTapped(_ sender: Any) {
        
        topButton.tintColor = UIColor.red
        liveButton.tintColor = UIColor.lightGray
        print("top button tapped")
        messageSortSelection = .top
        
    }
    
    
    
    var sortedMessagesByTimestamp: [Message] {
        return chat!.messages.sorted { return $0.timestamp.compare($1.timestamp as Date) == .orderedAscending}
    }
    
    var sortedMessagesByScore: [Message] {
        return chat!.messages.sorted { return $0.score > $1.score }
    }
    
    private func updateViews() {
        //do stuff to stuff
        guard let chat = chat, isViewLoaded else { return }
        
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        
        tableView.reloadData()

    }   
    //MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateViews()
        customize()
        
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "recieverCell", for: indexPath) as? RecieverTableViewCell else { return RecieverTableViewCell() }
        
        guard let chat = chat else { return cell }
        
        
//        switch messageSortSelection {
//        case .live:
//            
//        case .top:
//            
//        }
        
        let message = sortedMessagesByScore[indexPath.row]
        
        cell.delegate = self
        cell.message = message
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return 86
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
        dismiss(animated: true, completion: nil)
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

    }
    
    
}



















