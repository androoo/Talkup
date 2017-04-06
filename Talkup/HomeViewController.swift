//
//  HomeViewController.swift
//  Talkup
//
//  Created by Andrew Ervin Gierke on 4/3/17.
//  Copyright © 2017 Androoo. All rights reserved.
//

import UIKit



class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, UserHeaderTableViewCellDelegate {
    
    //MARK: - Outlets
    
    
    
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet weak var tableViewTopContraint: NSLayoutConstraint!
    
    @IBOutlet var tableViewBG: UIView!
    
    @IBOutlet weak var navbarBackgroundUIView: UIView!
    
    
    //MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Talkup"
        
        tableView.backgroundColor = .clear
        
        tableView.contentInset = UIEdgeInsets(top: 36, left: 0, bottom: 0, right: 0)
        
        updateViews()
        
        self.tableView.tableHeaderView = UIView()
        
        requestFullSync()
        
        customize()
        
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(postsChanged(_:)), name: ChatController.ChatsDidChangeNotification, object: nil)
        nc.addObserver(self, selector: #selector(updateViews), name: Notification.Name("syncingComplete"), object: nil)
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
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0: return 1
        case 1: return 1
        case 2: return ChatController.shared.chats.count
        case 3: return 1
        default: return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "firstCell", for: indexPath) as? FirstChatTableViewCell else { return FirstChatTableViewCell() }
            
            cell.separatorInset.left = 0
            cell.separatorInset.right = 0
            
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "filterCell", for: indexPath) as? FilterTableViewCell else { return FilterTableViewCell() }
            
            cell.separatorInset.left = 86.0
            
            return cell
        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "chatCell", for: indexPath) as? ChatTableViewCell else { return ChatTableViewCell() }
            
            let chat = ChatController.shared.chats[indexPath.row]
            cell.chat = chat
            cell.chatRankLabel.text = "\(indexPath.row + 1)"
            
            cell.separatorInset.left = 86.0

            return cell
            
        case 3:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "lastCell", for: indexPath) as? LastTableViewCell else { return LastTableViewCell() }
            return cell
            
        default:
            let cell = UITableViewCell()
            return cell
        }
        
    }
    
    //MARK: - Section Header
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableCell(withIdentifier: "headerCell") as! HeaderTableViewCell
        
        let user = UserController.shared.currentUser
        
        header.avatarImageView.image = user?.photo
        
        header.delegate = self
        
        return header
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        let tableHeight: CGFloat = tableView.bounds.size.height
        let index = 0
        
        switch section {
        case 0:
            view.transform = CGAffineTransform(translationX: 0, y: -200)
            UIView.animate(withDuration: 1.0, delay: 0.05 * Double(index),usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [], animations: { () -> Void in
                view.transform = CGAffineTransform(translationX: 0, y: 0)
            }, completion: nil)
        default:
            break
        }
    }
    

    
    //MARK: - Header Delegate 
    
    func didSelectUserHeaderTableViewCell(Selected: Bool, UserHeader: HeaderTableViewCell) {
        print("Cell selected")
    }

    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {

        switch section {
        case 0:
            return 75.0
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0: return 76
        case 1: return UITableViewAutomaticDimension
        case 2: return 76
        case 3: return 0
        default: return 86
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let maskPathTop = UIBezierPath(roundedRect: cell.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 13.0, height: 13.0))
        let shapeLayerTop = CAShapeLayer()
        shapeLayerTop.frame = cell.bounds
        shapeLayerTop.path = maskPathTop.cgPath

//        cell.separatorInset.left = 1000.0
        
        
        switch indexPath.section {

        case 0:
            return cell.layer.mask = shapeLayerTop
        default:
            break
        }
        

    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toChatDetail" {
            if let detailViewController = segue.destination as? ChatViewController,
                let selectedIndexPath = self.tableView.indexPathForSelectedRow {
                
                let backItem = UIBarButtonItem()
                backItem.title = ""
                navigationItem.backBarButtonItem = backItem
                
                let chats = ChatController.shared.chats
                
                detailViewController.chat = chats[selectedIndexPath.row]
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < 0 {
//            titleBotomContraint.constant += scrollView.contentOffset.y / 2
        }
    }
    
    func updateViews() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    //MARK: - Appearance Helpers
    
    func customize() {
        
        //        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
//        self.tableView.separatorInset = UIEdgeInsets(top: 0, left: 84, bottom: 0, right: 0)
        
//        tableView.layer.cornerRadius = 12
        
        view.backgroundColor = .clear
    }
}
