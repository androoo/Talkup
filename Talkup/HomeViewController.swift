//
//  HomeViewController.swift
//  Talkup
//
//  Created by Andrew Ervin Gierke on 4/3/17.
//  Copyright © 2017 Androoo. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: - Properties
    
    @IBOutlet var tableView: UITableView!
    
    //MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Talkup"
        
        updateViews()
        
        requestFullSync()
        
        customize()
        
        /*
         let newChatButton = UIButton(frame: CGRect(origin: CGPoint(x: self.view.frame.width - 75, y: self.view.frame.height - 75), size: CGSize(width: 50, height: 50)))
         
         newChatButton.backgroundColor = Colors.purple
         newChatButton.layer.cornerRadius = 25
         newChatButton.clipsToBounds = true
         
         self.navigationController?.view.addSubview(newChatButton)
         
         */
        
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(postsChanged(_:)), name: ChatController.ChatsDidChangeNotification, object: nil)
        nc.addObserver(self, selector: #selector(updateViews), name: Notification.Name("syncingComplete"), object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        updateViews()
    }
    
    
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
            if let detailViewController = segue.destination as? ChatDetailTableViewController,
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
        view.backgroundColor = Colors.gray
        
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        
        tableView.layer.cornerRadius = 0
        tableView.layer.masksToBounds = true
        
        tableView.layer.cornerRadius = 12
        view.backgroundColor = Colors.designBlue
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        
    }
    
}
