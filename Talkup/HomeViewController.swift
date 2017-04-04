//
//  HomeViewController.swift
//  Talkup
//
//  Created by Andrew Ervin Gierke on 4/3/17.
//  Copyright © 2017 Androoo. All rights reserved.
//

import UIKit



class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, PageViewControllerScrollDelegate {
    
    //MARK: - Properties
    
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet weak var tableViewTopContraint: NSLayoutConstraint!
    @IBOutlet var tableViewBG: UIView!
    
    @IBOutlet weak var navbarBackgroundUIView: UIView!
    
    
    //MARK: - status bar 
    

    
    
    //MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Talkup"
        
        updateViews()
        
        requestFullSync()
        
        customize()
        
        
        /*
        let addImage = UIImage(named: "addChatButton")
        
        let newChatButton = UIButton(frame: CGRect(origin: CGPoint(x: self.view.frame.width / 2 - 44, y: self.view.frame.height - 100), size: CGSize(width: 88, height: 88)))
        newChatButton.setImage(addImage, for: .normal)
        newChatButton.addTarget(self, action: #selector(addChat(button:)), for: .touchUpInside)
        newChatButton.layer.cornerRadius = 25
        newChatButton.clipsToBounds = true
        
        self.view.addSubview(newChatButton)
        */
        
        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(postsChanged(_:)), name: ChatController.ChatsDidChangeNotification, object: nil)
        nc.addObserver(self, selector: #selector(updateViews), name: Notification.Name("syncingComplete"), object: nil)
        
        
        navbarBackgroundUIView.applyNavGradient(colours: [Colors.clearBlack, .clear])
        navbarBackgroundUIView.applyNavGradient(colours: [Colors.clearBlack, .clear], locations: [0.0, 1.0])
        
        
    }
    
    func addChat(button: UIButton) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "newChatNav") as? NavViewController else { return }
        self.present(vc, animated: false, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        updateViews()
    }
    
    //MARK: - TableView detect scrolling 
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView.contentOffset.y > 0 && scrollView.contentOffset.y < 100 {
            tableViewTopContraint.constant -= scrollView.contentOffset.y

            
        }
        
        if scrollView.contentOffset.y < 0 && scrollView.contentOffset.y > -64 {
            tableViewTopContraint.constant -= scrollView.contentOffset.y
        }
        
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ChatController.shared.chats.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "chatCell", for: indexPath) as? ChatTableViewCell else { return ChatTableViewCell() }
        
        let chat = ChatController.shared.chats[indexPath.row]
        cell.chat = chat
        cell.chatRankLabel.text = "\(indexPath.row + 1)"
        
        
        return cell
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toChatDetail" {
            if let detailViewController = segue.destination as? ChatViewController,
                let selectedIndexPath = self.tableView.indexPathForSelectedRow {
                
                let backItem = UIBarButtonItem()
                backItem.title = ""
                navigationItem.backBarButtonItem = backItem
                
                let chats = ChatController.shared.chats
                
                detailViewController.chat = chats[selectedIndexPath.row]
            }
        }
        
    }
    
    func updateViews() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    //MARK: - Appearance Helpers
    
    func customize() {
        view.backgroundColor = Colors.gray
        
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        
        tableView.layer.cornerRadius = 0
        tableView.layer.masksToBounds = true
        
        tableView.layer.cornerRadius = 12
        view.backgroundColor = .clear
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        
        
        
    }
    
    func fadeColor(_ sender: PageViewController) {
        view.backgroundColor = UIColor.black
    }
    
}
