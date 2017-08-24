//
//  ChatTopicsListViewController.swift
//  Talkup
//
//  Created by Andrew Ervin Gierke on 8/18/17.
//  Copyright © 2017 Androoo. All rights reserved.
//

import UIKit

class ChatTopicsListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate {
    
    var chats: [Chat]? {
        didSet {
            updateViews()
        }
    }
    
    var user: User?
    
    lazy var customTransitioningDelegate = CustomPushTransitionController()

    @IBAction func dismissButtonTapped(_ sender: Any) {
        dismiss(animated: true) { 
            
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var navbarView: UIView!
    @IBOutlet weak var navbarTitleLabel: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateViews()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
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
        if segue.identifier == "toChatFromTopics" {
            guard let destination = segue.destination as? ChatViewController,
                let indexPath = tableView.indexPathForSelectedRow else { return }
            
            let backItem = UIBarButtonItem()
            backItem.title = ""
            navigationItem.backBarButtonItem = backItem
            
            let chat = user?.chats[indexPath.row]
            chat?.isDismisable = true
            destination.chat = chat
            
            let navigationController = segue.destination
            navigationController.transitioningDelegate = customTransitioningDelegate
            navigationController.modalPresentationStyle = .custom
            
        }
    }
    
    func updateViews() {
        guard let user = user, isViewLoaded else { return }
        
        navbarView.backgroundColor = Colors.navbarGray
        
        UserController.shared.fetchMessagesBy(user: user) { 
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}
