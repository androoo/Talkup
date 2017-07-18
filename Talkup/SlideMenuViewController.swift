//
//  SlideMenuViewController.swift
//  Talkup
//
//  Created by Andrew Ervin Gierke on 7/17/17.
//  Copyright © 2017 Androoo. All rights reserved.
//

import UIKit

class SlideMenuViewController: UIViewController {
    
    //MARK: - Properties 
    
    var user: User? {
        didSet {
            updateViews()
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    
    //MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func updateViews() {
        
    }

}
