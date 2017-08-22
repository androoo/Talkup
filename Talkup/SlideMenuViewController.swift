//
//  SlideMenuViewController.swift
//  Talkup
//
//  Created by Andrew Ervin Gierke on 7/17/17.
//  Copyright © 2017 Androoo. All rights reserved.
//

import UIKit

class SlideMenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate {
    
    //MARK: - Properties
    
    var menuItems: [String] = [
        "My Profile",
        "My Topics",
        "Help"
    ]
    
    //VC transitions
//    lazy var customPushTransitioningDelegate = CustomPushTransitionCotroller()
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var chatsCountLabel: UILabel!
    @IBOutlet weak var messagesCountLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    lazy var customTransitioningDelegate = CustomPushTransitionController()
    
    //MARK: - TableView Datasource/Delegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell", for: indexPath) as? MenuTableViewCell else { return MenuTableViewCell() }
        
        cell.itemName = menuItems[indexPath.row]
        
        return cell
    }
    
    
    //MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let user = UserController.shared.currentUser else { return }
        
        userImageView.image = user.photo
        userImageView.layer.cornerRadius = userImageView.layer.frame.width / 2
        userImageView.layer.masksToBounds = true
        nameLabel.text = user.userName
        nameLabel.textColor = Colors.primaryDark
        userNameLabel.text = user.email
        userNameLabel.textColor = Colors.primaryDarkGray
        
        chatsCountLabel.text = "\(user.chats.count)"
        
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    // need to check which menu item clicked
    // need to send the user to the page too
        
        if segue.identifier == "toMyProfile" {
            
            if let detailViewController = segue.destination as? UserDetailViewController,
                let selectedIndexPath = self.tableView.indexPathForSelectedRow {
                
                let backItem = UIBarButtonItem()
                backItem.title = ""
                navigationItem.backBarButtonItem = backItem
                
                let navigationController = segue.destination
                
                let chat = UserController.shared.currentUserDirectChat
                chat?.isDismisable = true
                detailViewController.chat = chat
                detailViewController.user = UserController.shared.currentUser
                detailViewController.isDirectChat = true
                
                navigationController.transitioningDelegate = customTransitioningDelegate
                navigationController.modalPresentationStyle = .custom
            }
        }
    }
}
