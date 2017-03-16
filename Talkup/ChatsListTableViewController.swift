//
//  ChatsListTableViewController.swift
//  Talkup
//
//  Created by Andrew Ervin Gierke on 3/13/17.
//  Copyright © 2017 Androoo. All rights reserved.
//

import UIKit

class ChatsListTableViewController: UITableViewController {
    
    //MARK: - Outlets
    
    //MARK: - Properties
    
    
    //MARK: - View lifecycle 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Talkup"
        
        requestFullSync()

        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(postsChanged(_:)), name: ChatController.ChatsDidChangeNotification, object: nil)
        
        
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
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ChatController.shared.chats.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "chatCell", for: indexPath) as? MessageTableViewCell else { return MessageTableViewCell() }
        
        let chats = ChatController.shared.chats
        cell.chat = chats[indexPath.row]
        cell.topicNumberLabel.text = "\(indexPath.row + 1)"
        cell.topicNumberLabel.textColor = UIColor.lightGray
        
        return cell
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toChatDetail" {
            if let detailViewController = segue.destination as? ChatDetailTableViewController,
                let selectedIndexPath = self.tableView.indexPathForSelectedRow {
                
                let chats = ChatController.shared.chats
                detailViewController.chat = chats[selectedIndexPath.row]
            }
        }
        
    }
}
















