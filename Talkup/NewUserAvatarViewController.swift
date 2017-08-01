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
    
    
    //MARK: - UI Actions
    
    func emptyFieldsAlert() {
        let alertController = UIAlertController(title: "Information Missing", message: "Check that you've added a profile image, filled out your email + username and try again", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    //MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toCreateNewUser" {
            let embedViewController = segue.destination as? PhotoSelectViewController
            embedViewController?.delegate = self
        }
    }
}

extension NewUserAvatarViewController: PhotoSelectViewControllerDelegate {
    func photoSelectViewControllerSelected(_ image: UIImage) {
        self.image = image
    }
}



