//
//  WelcomeViewController.swift
//  Talkup
//
//  Created by Andrew Ervin Gierke on 3/14/17.
//  Copyright © 2017 Androoo. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    
    //MARK: - Properties 
    
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var talkupLabel: UILabel!
    @IBOutlet weak var aboutTextLabel: UILabel!
    @IBOutlet weak var talkupLogoImageView: UIImageView!
    
    
    //MARK: - View lifecycle
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        signUpButton.layer.cornerRadius = 8.0
        signUpButton.layer.masksToBounds = true
        talkupLabel.font = UIFont.appWelcomeTitlerFont
        talkupLabel.textColor = .white
        aboutTextLabel.textColor = .white
        
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
    }
    
}
