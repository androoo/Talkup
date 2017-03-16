//
//  ChatDetailTableViewController.swift
//  Talkup
//
//  Created by Andrew Ervin Gierke on 3/13/17.
//  Copyright © 2017 Androoo. All rights reserved.
//

import UIKit

class ChatDetailTableViewController: UITableViewController, UITextFieldDelegate {
    
    //MARK: - Properties
    
    var chat: Chat? {
        didSet {
            updateViews()
        }
    }
    
    private func updateViews() {
        //do stuff to stuff
        guard let chat = chat, isViewLoaded else { return }
        
        tableView.reloadData()
        
        ChatController.shared.checkSubscriptionTo(messagesForChat: chat) { (subscribed) in
            
        }
    }
    
    //MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchMessages()
        
        updateViews()
        
        guard let chat = chat, isViewLoaded else { return }
        title = "\(chat.topic)"
        
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(chatMessagesChanged(_:)), name: ChatController.ChatMessagesChangedNotification, object: nil)
    }
    
    // MARK: Notifications
    
    func chatMessagesChanged(_ notification: Notification) {
        guard let notificationChat = notification.object as? Chat,
            let chat = chat, notificationChat === chat else { return } // Not our post
        updateViews()
    }
    
    func fetchMessages() {
        guard let currentChat = chat else { return }
        MessageController.fetchMessagesFor(chat: currentChat) {
            
        }
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chat?.messages.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "recieverCell", for: indexPath) as? MessageTableViewCell else { return MessageTableViewCell() }
        
        guard let chat = chat else { return cell }
        let message = chat.messages[indexPath.row]
        
        cell.chatMessageLabel.text = message.text
        
        return cell
    }
    
    
    //MARK: - Chat Input 
    
    @IBAction func sendChatMessageButtonTapped(_ sender: Any) {
        //let message == textinput init Message 
        //message.send 
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

}
