//
//  ChatViewController.swift
//  Talkup
//
//  Created by Andrew Ervin Gierke on 4/3/17.
//  Copyright © 2017 Androoo. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, RecieverTableViewCellDelegate, filterHeaderDelegate {

    //MARK: - Outlets
    
    @IBOutlet weak var navBarViewBgView: UIView!
    @IBOutlet weak var liveButton: UIButton!
    @IBOutlet weak var topButton: UIButton!
    @IBOutlet weak var nowLabel: UILabel!
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var followingButtonImageView: UIImageView!
    @IBOutlet weak var liveButtonBottomBorder: UIImageView!
    @IBOutlet weak var topButtonBottomBorder: UIImageView!
    @IBOutlet weak var navBarBottomBorderImageView: UIImageView!
    @IBOutlet weak var sendMessageButtonTapped: UIButton!
    @IBOutlet weak var chatTitleLabel: UILabel!
    
    //MARK: - Properties
    @IBOutlet var tableView: UITableView!
    
    var followButton: FollowingButton?
    
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
    
    var timeOfLastVisit: Date?
    
    //MARK: - UIActions
    
    @IBAction func liveButton(_ sender: Any) {
        liveButton.setTitleColor(Colors.flatYellow, for: .normal)
        topButton.setTitleColor(UIColor.lightGray, for: .normal)
        nowLabel.textColor = Colors.flatYellow
        topLabel.textColor = Colors.primaryDarkGray
        liveButtonBottomBorder.backgroundColor = Colors.flatYellow
        topButtonBottomBorder.backgroundColor = Colors.primaryLightGray
        messageSortSelection = .live
        updateViews()
    }

    @IBAction func topButton(_ sender: Any) {
        liveButton.setTitleColor(UIColor.lightGray, for: .normal)
        topButton.setTitleColor(Colors.greenBlue, for: .normal)
        topLabel.textColor = Colors.greenBlue
        nowLabel.textColor = Colors.primaryDarkGray
        topButtonBottomBorder.backgroundColor = Colors.greenBlue
        liveButtonBottomBorder.backgroundColor = Colors.primaryLightGray
        messageSortSelection = .top
        updateViews()
    }
    
    @IBAction func followingButtonTapped(_ sender: Any) {
        
        guard let chat = chat,
             let user = UserController.shared.currentUser else { return }
        
        ChatController.shared.followMessagesIn(chat: chat)
        
        
        if followButton == .pressed {
            followingButtonImageView.image = UIImage(named: "subscribe")
            // remove chat from followed list 
            followButton = .notPressed
        } else {
            followingButtonImageView.image = UIImage(named: "subscribed")
            UserController.shared.followChat(Foruser: user, chat: chat)
            followButton = .pressed
        }
        
        ChatController.shared.toggleSubscriptionTo(chatNammed: chat) { (_, _, _) in
            
            DispatchQueue.main.async {
                self.updateViews()
            }
        }
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
        
        ChatController.shared.checkSubscriptionTo(chat: chat) { (subscription) in
            if subscription {
                self.followButton = .pressed
                
            } else {
                self.followButton = .notPressed
            }
            
            DispatchQueue.main.async {
                self.followButtonAppearance()
            }
        }
        
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
    }
    
    //MARK: - View lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        liveButton.setTitleColor(Colors.flatYellow, for: .normal)
        nowLabel.textColor = Colors.flatYellow
        liveButtonBottomBorder.backgroundColor = Colors.flatYellow
        topButtonBottomBorder.backgroundColor = Colors.primaryLightGray
        
        
        updateViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        sendMessageButtonTapped.isEnabled = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = true
        
        tableView.backgroundColor = .white
        
        navBarViewBgView.backgroundColor = .white
        
        //add shadow to top part 
        
//        chatCreatorAvatar.image = chat?.creator?.photo
//        chatCreatorAvatar.layer.cornerRadius = chatCreatorAvatar.frame.width / 2
//        chatCreatorAvatar.clipsToBounds = true
        
        guard let name = chat?.topic else { return }
        inputTextField.delegate = self
        updateViews()
        customize()
        navBarBottomBorderImageView.backgroundColor = .white
        liveButtonBottomBorder.isHidden = false
        
        title = "\(name)"
        chatTitleLabel.text = "\(name)"
        chatTitleLabel.textColor = Colors.primaryBgPurple
        chatTitleLabel.font = UIFont(name: "ArialRoundedMTBold", size: 20)
        
        guard let chat = chat, isViewLoaded else { return }
        title = "\(chat.topic)"
        
        //        self.navigationItem.titleView = setTitle(title: "\(chat.topic)", subtitle: "45 people")
        
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
        
        guard let header = tableView.dequeueReusableCell(withIdentifier: "filterHeader") as? FilterHeaderTableViewCell else { return FilterHeaderTableViewCell() }
        
        header.delegate = self
        
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 55
    }
    
    
    // set up the cells 
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        switch indexPath.section {
        case 0:
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "headerCell", for: indexPath) as? ChatHeaderTableViewCell else { return ChatHeaderTableViewCell() }
            
            cell.chat = chat
            cell.backgroundColor = Colors.primaryLightGray
            
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
    
    
    //MARK: - Customize Appearance
    
    func customize() {
        
        //        self.tableView.estimatedRowHeight = self.barHeight
        self.tableView.contentInset.bottom = self.barHeight
        self.tableView.scrollIndicatorInsets.bottom = self.barHeight
    }
    
    
    // follow button appearance
    
    func followButtonAppearance() {
        
        //toggle follow button appearance
        
        if followButton == .pressed {
            // subscribed is the check
            followingButtonImageView.image = UIImage(named: "subscribed")
        } else {
            // subscribe is the plus
            followingButtonImageView.image = UIImage(named: "subscribe")
        }
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
    
    //MARK: - Filter Header Delegate 
    
    func nowSortButtonClicked(selected: Bool, filterHeader: FilterHeaderTableViewCell) {
        print("Now selected")
    }
    
    func topSortButtonClicked() {
        print("top button clicked")
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
            
            if let destinationViewController = segue.destination as? UserViewController {
                
                destinationViewController.user = user
            }
        }
    }
    
    func usernameClicked(user: User) {
        
        self.user = user
        
        self.performSegue(withIdentifier: "toUserDetail", sender: nil)
    }
}

