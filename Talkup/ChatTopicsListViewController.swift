//
//  ChatTopicsListViewController.swift
//  Talkup
//
//  Created by Andrew Ervin Gierke on 8/18/17.
//  Copyright © 2017 Androoo. All rights reserved.
//

import UIKit

class ChatTopicsListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var chats: [Chat]? {
        didSet {
            updateViews()
        }
    }
    
    var user: User?

    @IBOutlet weak var tableView: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let chats = user?.chats.count else { return 1 }
        return chats
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "topicCell", for: indexPath) as? TopicCellTableViewCell else { return TopicCellTableViewCell() }
        
        cell.separatorInset.left = 32.0
        
        let chat = user?.chats[indexPath.row]
        cell.chat = chat
        cell.user = user
        
        return cell
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
    func updateViews() {
        guard let user = user, isViewLoaded else { return }
        UserController.shared.fetchMessagesBy(user: user) { 
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}
