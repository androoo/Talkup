//
//  SlideMenuViewController.swift
//  Talkup
//
//  Created by Andrew Ervin Gierke on 7/17/17.
//  Copyright © 2017 Androoo. All rights reserved.
//

import UIKit

class SlideMenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate, MenuDelegate {
    
    //MARK: - Properties
    
    //    lazy var customPushTransitioningDelegate = CustomPushTransitionCotroller()
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    lazy var customTransitioningDelegate = CustomPushTransitionController()
    
    //MARK: - TableView Datasource/Delegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        switch indexPath.row {
            
        case 0:
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "menuProfileCell", for: indexPath) as? MenuProfileTableViewCell else { return MenuProfileTableViewCell() }
        
        cell.title = "My Profile"
        cell.delegate = self
        
        return cell
            
        case 1:
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "menuTopicsCell", for: indexPath) as? MenuTopicsTableViewCell else { return MenuTopicsTableViewCell() }
        
        cell.title = "My Chats"
        cell.delegate = self
        
        return cell
            
        case 2:
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "menuHelpCell", for: indexPath) as? MenuHelpTableViewCell else { return MenuHelpTableViewCell() }
        
        cell.title = "Help"
        cell.delegate = self 
        
        return cell
            
        default: return UITableViewCell()
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
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
        nameLabel.font = UIFont(name: "ArialRoundedMTBold", size: 36)
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // need to check which menu item clicked
        // need to send the user to the page too
        
        if segue.identifier == "toMyProfile" {
            
            if let detailViewController = segue.destination as? UserDetailViewController {
                
                let backItem = UIBarButtonItem()
                backItem.title = ""
                navigationItem.backBarButtonItem = backItem
                
                let chat = UserController.shared.currentUserDirectChat
                chat?.isDismisable = true
                detailViewController.chat = chat
                detailViewController.user = UserController.shared.currentUser
                detailViewController.isDirectChat = true
                
                let navigationController = segue.destination
                navigationController.transitioningDelegate = customTransitioningDelegate
                navigationController.modalPresentationStyle = .custom
                
            }
        } else if segue.identifier == "toMyTopics" {
            
            if let detailViewController = segue.destination as? ChatTopicsListViewController {
                
                let backItem = UIBarButtonItem()
                backItem.title = ""
                navigationItem.backBarButtonItem = backItem
                
                detailViewController.user = UserController.shared.currentUser
                
                let navigationController = segue.destination
                navigationController.transitioningDelegate = customTransitioningDelegate
                navigationController.modalPresentationStyle = .custom
                
            }
        }
    }
    
    func selectedRow(index: Int) {
        if (index == 0) {
            self.performSegue(withIdentifier: "toMyProfile", sender: self)
        } else if (index == 1) {
            self.performSegue(withIdentifier: "toMyTopics", sender: self)
        } else {
            print(3)
        }
        
    }
    
}
