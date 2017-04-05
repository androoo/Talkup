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
    
    
    //MARK: - TableView Scroll feature
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        print(scrollView.contentOffset)
        
        if scrollView.contentOffset.y > 0 && scrollView.contentOffset.y < 100 {
            tableViewTopContraint.constant -= scrollView.contentOffset.y
            
        }
        
        if tableViewTopContraint.constant <= 54 {
            if scrollView.contentOffset.y < 0 && scrollView.contentOffset.y > -64 {
                tableViewTopContraint.constant -= scrollView.contentOffset.y
            }
        }
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ChatController.shared.chats.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "chatCell", for: indexPath) as? ChatTableViewCell else { return ChatTableViewCell() }
        
        let chat = ChatController.shared.chats[indexPath.row]
        cell.chat = chat
        cell.chatRankLabel.text = "\(indexPath.row + 1)"
        
        return cell
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
        self.tableView.separatorInset = UIEdgeInsets(top: 0, left: 84, bottom: 0, right: 0)

        tableView.layer.cornerRadius = 12
        
        view.backgroundColor = .clear
    }
}
