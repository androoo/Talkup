//
//  SlideMenuViewController.swift
//  Talkup
//
//  Created by Andrew Ervin Gierke on 7/17/17.
//  Copyright © 2017 Androoo. All rights reserved.
//

import UIKit

class SlideMenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: - Properties 
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var chatsCountLabel: UILabel!
    @IBOutlet weak var messagesCountLabel: UILabel!

    
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - TableView Datasource/Delegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell", for: indexPath) as? MenuTableViewCell else { return MenuTableViewCell() }
        
    
        
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
        
    }
    

}
