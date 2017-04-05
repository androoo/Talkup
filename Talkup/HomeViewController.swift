//
//  HomeViewController.swift
//  Talkup
//
//  Created by Andrew Ervin Gierke on 4/3/17.
//  Copyright © 2017 Androoo. All rights reserved.
//

import UIKit



class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    
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
        case 0 : return 1
        case 1: return 1
        case 2: return 1
        case 3: return ChatController.shared.chats.count
        default: return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "headerCell", for: indexPath) as! HeaderTableViewCell
            
            cell.separatorInset.left = 1000.0
            
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "firstCell", for: indexPath) as? FirstChatTableViewCell else { return FirstChatTableViewCell() }
            
            cell.separatorInset.left = 0
            cell.separatorInset.right = 0
            
            return cell
        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "filterCell", for: indexPath) as? FilterTableViewCell else { return FilterTableViewCell() }
            
            cell.separatorInset.left = 86.0
            
            return cell
        case 3:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "chatCell", for: indexPath) as? ChatTableViewCell else { return ChatTableViewCell() }
            
            let chat = ChatController.shared.chats[indexPath.row]
            cell.chat = chat
            cell.chatRankLabel.text = "\(indexPath.row + 1)"
            
            cell.separatorInset.left = 86.0

            
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "emptyCell", for: indexPath) as! UITableViewCell
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0: return UITableViewAutomaticDimension
        case 1: return 86
        case 2: return UITableViewAutomaticDimension
        case 3: return 86
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

        case 1:
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
