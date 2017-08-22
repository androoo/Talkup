//
//  NewUserAvatarViewController.swift
//  Talkup
//
//  Created by Andrew Ervin Gierke on 7/28/17.
//  Copyright © 2017 Androoo. All rights reserved.
//

import UIKit

class NewUserAvatarViewController: UIViewController {
    
    //MARK: - Properties 

    var image: UIImage?
    var accessCode: String?
    var username: String?
    
    
    //MARK: - Outlets
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var continueButton: UIButton!
    
    
    //MARK: - UI Actions
    
    func emptyFieldsAlert() {
        let alertController = UIAlertController(title: "Information Missing", message: "Check that you've added a profile image, filled out your email + username and try again", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    //MARK: - View lifecycle 
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        self.navigationController?.navigationBar.tintColor = Colors.primaryBgPurple
    }
    
    override func viewDidLoad() {
        usernameLabel.text = username
        
    }
    
    //MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
        
        if segue.identifier == "embedPhotoSelect" {
            
            let embedViewController = segue.destination as? PhotoSelectViewController
            embedViewController?.delegate = self
            
        }
        
        if segue.identifier == "toAddEmail" {
            
            if let detailViewController = segue.destination as? AddEmailViewController {
                detailViewController.userName = self.username
                detailViewController.image = self.image
                detailViewController.accessCode = self.accessCode
            }
        }
    }
}

extension NewUserAvatarViewController: PhotoSelectViewControllerDelegate {
    func photoSelectViewControllerSelected(_ image: UIImage) {
        self.image = image
    }
}



