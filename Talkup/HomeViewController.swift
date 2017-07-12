//
//  HomeViewController.swift
//  Talkup
//
//  Created by Andrew Ervin Gierke on 4/3/17.
//  Copyright © 2017 Androoo. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    //MARK: - Properties 
    
    var recentMessages: [Message]? {
        
        return ChatController.shared.followingChats.first?.messages
        
    }
    
    var searchBar: UISearchBar?
    
    @IBOutlet weak var headerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var addTalkUpIconTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var userIconTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var currentUserHeaderImageView: UIImageView!
    @IBOutlet weak var addChatIconImageView: UIImageView!
    
    @IBOutlet weak var headerBackgroundView: UIView!
    @IBOutlet weak var headerBigTitleLabel: UILabel!
    
    @IBOutlet weak var recentMessagesCollectionView: UICollectionView!
    
    @IBOutlet weak var searchTextField: UITextField!
    
    
    let maxHeaderHeight: CGFloat = 150
    let minHeaderHeight: CGFloat = 74
    
    var previousScrollOffset: CGFloat = 0
    
    var searchController: UISearchController?
    
    //MARK: - Outlets
    
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var tableViewBG: UIView!
    
    @IBOutlet weak var navbarBackgroundUIView: UIView!
    
    //main view for custom nav bar
    @IBOutlet weak var topNavBarBackgroundView: UIView!
    @IBOutlet weak var mainNavBottomSep: UIImageView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var backgroundNavbarTitleLabel: UILabel!
    @IBOutlet weak var bigNavbarTitle: UILabel!
    @IBOutlet weak var smallNavbarTitle: UILabel!
    @IBOutlet weak var userIconSmall: UIImageView!
    
    @IBOutlet weak var topNavBarTitleConstraint: NSLayoutConstraint!
    
    var flowLayout: UICollectionViewFlowLayout?
    
    //MARK: - View lifecycle
    
    
    //navbar actions
    
    @IBAction func unwindToHome(segue:UIStoryboardSegue) { }
    @IBAction func profileButtonTapped(_ sender: Any) { }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpSearch()
        
        topNavBarBackgroundView.backgroundColor = .white
        self.flowLayout?.estimatedItemSize = CGSize(width: 100, height: 100)
        guard let user = UserController.shared.currentUser else { return }
        
        currentUserHeaderImageView.image = user.photo
        currentUserHeaderImageView.layer.cornerRadius = currentUserHeaderImageView.layer.frame.width / 2
        currentUserHeaderImageView.layer.masksToBounds = true
        
        self.navigationController?.navigationBar.isHidden = true 
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        tableView.backgroundColor = .clear
        
        view.backgroundColor = .white
        
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        updateViews()
        
        self.tableView.tableHeaderView = UIView()
        
        requestFullSync()
        
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(postsChanged(_:)), name: ChatController.ChatsDidChangeNotification, object: nil)
        nc.addObserver(self, selector: #selector(updateViews), name: Notification.Name("syncingComplete"), object: nil)
    }
    
    func setUpSearch() {
        searchBar = UISearchBar(frame: CGRect(x: Int(currentUserHeaderImageView.frame.maxX + 8), y: Int(currentUserHeaderImageView.frame.minY), width: Int(addChatIconImageView.frame.minX - 32), height: Int(currentUserHeaderImageView.frame.height)))
        
        topNavBarBackgroundView.addSubview(searchBar!)
    }
    
    func addChat(button: UIButton) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "newChatNav") as? NavViewController else { return }
        self.present(vc, animated: false, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        updateViews()
        tableView.setNeedsLayout()
    }
    
    
    
    //MARK: - Sync data
    
    private func requestFullSync(_ completion: (() -> Void)? = nil) {
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        ChatController.shared.performFullSync {
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            
            completion?()
        }
    }
    
    
    // MARK: Notifications
    
    func postsChanged(_ notification: Notification) {
        tableView.reloadData()
    }
    
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if UserController.shared.currentUser?.following == nil {
            return 3
        } else {
            return 4
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if UserController.shared.currentUser?.following == nil {
            switch section {
            case 0: return 1
            case 1: return ChatController.shared.chats.count
            case 2: return 1
            default: return 1
            }
        } else {
            switch section {
            case 0: return 1
            case 1: return ChatController.shared.followingChats.count
            case 2: return ChatController.shared.chats.count
            case 3: return 1
            default: return 1
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if UserController.shared.currentUser?.following == nil {
            
            switch indexPath.section {
                
            case 0:
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "recentChatsCell", for: indexPath)
                
                return cell
                
            case 1:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "chatCell", for: indexPath) as? ChatTableViewCell else { return ChatTableViewCell() }
                
                let chat = ChatController.shared.chats[indexPath.row]
                cell.chat = chat
                cell.chatRankLabel.text = "\(indexPath.row + 1)"
                
                let customSelectedView = UIView()
                customSelectedView.backgroundColor = Colors.primaryLightGray
                cell.selectedBackgroundView = customSelectedView
                
                return cell
                
            case 2:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "lastCell", for: indexPath) as? LastTableViewCell else { return LastTableViewCell() }
                return cell
                
            default:
                let cell = UITableViewCell()
                return cell
            }
            
        } else {
            
            switch indexPath.section {
                
            case 0:
                
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "recentChatsCell", for: indexPath) as? RecentMessageCollectionTableViewCell else { return RecentMessageCollectionTableViewCell() }
                
                cell.backgroundColor = .clear 
                cell.setAppearance()
                
                return cell
                
            case 1:
                
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "followChat", for: indexPath) as? FollowingChatTableViewCell else {
                    return FollowingChatTableViewCell()
                }
                
                let chat = ChatController.shared.followingChats[indexPath.row]
                
                cell.chat = chat
                
                let customSelectedView = UIView()
                customSelectedView.backgroundColor = Colors.primaryLightGray
                cell.selectedBackgroundView = customSelectedView
                
                return cell
                
            case 2:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "chatCell", for: indexPath) as? ChatTableViewCell else {
                    return ChatTableViewCell()
                }
                
                let chat = ChatController.shared.chats[indexPath.row]
                cell.chat = chat
                cell.chatRankLabel.text = "\(indexPath.row + 1)"
                
                let customSelectedView = UIView()
                customSelectedView.backgroundColor = Colors.primaryLightGray
                cell.selectedBackgroundView = customSelectedView
                
                return cell
                
            case 3:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "lastCell", for: indexPath) as? LastTableViewCell else { return LastTableViewCell() }
                return cell
                
            default:
                let cell = UITableViewCell()
                return cell
            }
        }
    }

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if UserController.shared.currentUser?.following == nil {
            switch indexPath.section {
            case 0: return 250
            case 1: return 76
            case 2: return UITableViewAutomaticDimension
            default: return 86
            }
        } else {
            switch indexPath.section {
            case 0: return 250
            case 1: return 76
            case 2: return 76
            case 3: return UITableViewAutomaticDimension
            default: return 86
            }
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 0:
            return nil
        case 1:
            guard let header = tableView.dequeueReusableCell(withIdentifier: "followTitle") as? FollowingTitleTableViewCell else { return FollowingTitleTableViewCell() }
            return header
        default:
            guard let header = tableView.dequeueReusableCell(withIdentifier: "filterCell") as? FilterTableViewCell else { return FilterTableViewCell() }
            return header
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        switch section {
        case 0:
            return 0
        default:
            return 76
        }
        
    }
    
    
    //MARK: - Collection View Datasource 
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let messages = recentMessages else { return 0 }
        return messages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "messageItemCell", for: indexPath) as? MessageItemCollectionViewCell else { return MessageItemCollectionViewCell() }
        
        guard let message = recentMessages?[indexPath.row]
            else { return MessageItemCollectionViewCell() }
        
        cell.message = message
        
        return cell
        
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        
//        let message = recentMessages?[indexPath.row]
//        
//        let messageSize = message!.text.size()
//        return CGSize(width: messageSize.width, height: messageSize.height)
//    }
    
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toChatDetail" {
            if let detailViewController = segue.destination as? ChatViewController,
                let selectedIndexPath = self.tableView.indexPathForSelectedRow {
                
                let backItem = UIBarButtonItem()
                backItem.title = ""
                navigationItem.backBarButtonItem = backItem
                
                let chat = ChatController.shared.chats[selectedIndexPath.row]
                chat.isDismisable = false
                detailViewController.chat = chat
            }
        } else if segue.identifier == "toFollowingDetail" {
            
            if let detailViewController = segue.destination as? ChatViewController,
                let selectedIndexPath = self.tableView.indexPathForSelectedRow {
                
                let backItem = UIBarButtonItem()
                backItem.title = ""
                navigationItem.backBarButtonItem = backItem
                
                let chat = ChatController.shared.followingChats[selectedIndexPath.row]
                chat.isDismisable = false
                detailViewController.chat = chat
                
            }
            
            
        }else if segue.identifier == "toMyProfile" {
                    guard let user = UserController.shared.currentUser
                        else { return }
                    
                    if let destinationViewController = segue.destination as? UserViewController {
                        
                        destinationViewController.user = user
                    
            }
        }
    }

    
    func updateViews() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}
