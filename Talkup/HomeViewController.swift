//
//  HomeViewController.swift
//  Talkup
//
//  Created by Andrew Ervin Gierke on 4/3/17.
//  Copyright © 2017 Androoo. All rights reserved.
//

import UIKit


class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchControllerDelegate, UINavigationControllerDelegate, UISearchResultsUpdating {
    
    //MARK: - Properties
    
    var recentMessages: [Message]? {
        return ChatController.shared.followingChats.first?.messages
    }
    
    var searchBar: UISearchBar?
    var searchController: UISearchController!
    @IBOutlet weak var searchBarView: UIView!
    @IBOutlet weak var navBarElementsTopConstraint: NSLayoutConstraint!
    
    var feedType: FeedFilter = .trending
    
    var chats: [Chat] {
        switch feedType {
        case .trending:
            return ChatController.shared.chats
        case .following:
            return ChatController.shared.followingChats
        case .recent:
            return ChatController.shared.chats
        case .featured:
            return ChatController.shared.chats
        }
    }
    
    //VC transitions
    let slideAnimator = SearchTransitionAnimator()
    let customNavigationAnimationController = SearchTransitionAnimator()
    lazy var slideInMenuTransitioningDelegate = SlideMenuTransitionController()
    let searchTransition = SearchbarAnimator()
    
    @IBOutlet weak var headerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var addTalkUpIconTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var userIconTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var currentUserHeaderImageView: UIImageView!
    @IBOutlet weak var addChatIconImageView: UIImageView!
    @IBOutlet weak var headerBackgroundView: UIView!
    @IBOutlet weak var headerBigTitleLabel: UILabel!
    @IBOutlet weak var recentMessagesCollectionView: UICollectionView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchTextFieldLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var navBarChatFilterLabel: UILabel!
    @IBOutlet weak var talkUpSearchTextField: UITextField!
    
    
    let maxHeaderHeight: CGFloat = 150
    let minHeaderHeight: CGFloat = 74
    
    var previousScrollOffset: CGFloat = 0
    
    
    //MARK: - Outlets
    
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var tableViewBG: UIView!
    
    @IBOutlet weak var navbarBackgroundUIView: UIView!
    
    //main view for custom nav bar
    @IBOutlet weak var topNavBarBackgroundView: UIView!
    @IBOutlet weak var mainNavBottomSep: UIImageView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var backgroundNavbarTitleLabel: UILabel!
    @IBOutlet weak var bigNavbarTitle: UILabel!
    @IBOutlet weak var smallNavbarTitle: UILabel!
    @IBOutlet weak var userIconSmall: UIImageView!
    
    @IBOutlet weak var topNavBarTitleConstraint: NSLayoutConstraint!
    
    var flowLayout: UICollectionViewFlowLayout?
    
    //MARK: - View lifecycle
    
    
    //navbar actions
    
    @IBAction func unwindToHome(segue:UIStoryboardSegue) { }
    @IBAction func profileButtonTapped(_ sender: Any) { }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let currenctUser = UserController.shared.currentUser else { return }
        
        setupSearchController()
        ChatController.shared.fetchDirectChat(forUser: currenctUser) { (chat) in
            UserController.shared.currentUserDirectChat = chat
        }
        
        searchTransition.dismissCompletion = {
            self.tableView.isHidden = false
        }
        
        navigationController?.navigationBar.isHidden = true
        
        topNavBarBackgroundView.backgroundColor = .white
        self.flowLayout?.estimatedItemSize = CGSize(width: 100, height: 100)
        guard let user = UserController.shared.currentUser else { return }
        
        currentUserHeaderImageView.image = user.photo
        currentUserHeaderImageView.layer.cornerRadius = currentUserHeaderImageView.layer.frame.width / 2
        currentUserHeaderImageView.layer.masksToBounds = true
        
        self.navigationController?.navigationBar.isHidden = true
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        tableView.backgroundColor = .clear
        
        view.backgroundColor = .white
        
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        updateViews()
        
        self.tableView.tableHeaderView = UIView()
        
        requestFullSync()
        
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(postsChanged(_:)), name: ChatController.ChatsDidChangeNotification, object: nil)
        nc.addObserver(self, selector: #selector(updateViews), name: Notification.Name("syncingComplete"), object: nil)
        
    }
    
    
    @IBAction func filterButtonTapped(_ sender: Any) {
        toggleFilter()
    }
    
    
    func addChat(button: UIButton) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "newChatNav") as? NavViewController else { return }
        self.present(vc, animated: false, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        updateViews()
        tableView.setNeedsLayout()
    }
    
    
    //MARK: - Search Controller
    
    func setupSearchController() {
        let resultsController = UIStoryboard(name: "SearchResults", bundle: nil).instantiateViewController(withIdentifier: "MainSearchResults")
        searchController = UISearchController(searchResultsController: resultsController)
        searchController.searchResultsUpdater = self
        definesPresentationContext = true
        searchController.hidesNavigationBarDuringPresentation = true
        //        searchBarView.addSubview(searchController.searchBar)
    }
    
    func updateSearchResults(for searchController: UISearchController) {
    }
    
    
    //MARK: - Sync data
    
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // will want to switch on an enum loading the different chat sources
        // ChatController.shared.followingChats.count
        
        // when VC loads need to see if the user follows chats and load that type first. Otherwise load trending chats first
        
        return ChatController.shared.chats.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "chatCell", for: indexPath) as? ChatTableViewCell else { return ChatTableViewCell() }
        
        let chat = self.chats[indexPath.row]
        cell.chat = chat
        cell.chatRankLabel.text = "\(indexPath.row + 1)"
        
        let customSelectedView = UIView()
        customSelectedView.backgroundColor = Colors.primaryLightGray
        cell.selectedBackgroundView = customSelectedView
        
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 96
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 96
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toChatDetail" {
            if let detailViewController = segue.destination as? ChatViewController,
                let selectedIndexPath = self.tableView.indexPathForSelectedRow {
                
                let backItem = UIBarButtonItem()
                backItem.title = ""
                navigationItem.backBarButtonItem = backItem
                
                let chat = ChatController.shared.chats[selectedIndexPath.row]
                chat.isDismisable = false
                detailViewController.chat = chat
            }
        } else if segue.identifier == "toFollowingDetail" {
            
            if let detailViewController = segue.destination as? ChatViewController,
                let selectedIndexPath = self.tableView.indexPathForSelectedRow {
                
                let backItem = UIBarButtonItem()
                backItem.title = ""
                navigationItem.backBarButtonItem = backItem
                
                let chat = ChatController.shared.followingChats[selectedIndexPath.row]
                chat.isDismisable = false
                detailViewController.chat = chat
                
            }
            
        } else if segue.identifier == "slideMenu" {
            guard UserController.shared.currentUser != nil
                else { return }
            
            if let destinationViewController = segue.destination as? SlideMenuViewController {
                
                destinationViewController.transitioningDelegate = slideInMenuTransitioningDelegate
                destinationViewController.modalPresentationStyle = .custom
                slideInMenuTransitioningDelegate.direction = .left
            }
            
        } else if segue.identifier == "toSearchResults" {
            
            if let destinationViewController = segue.destination as? MainSearchResultsViewController {
                
                destinationViewController.transitioningDelegate = self
                
            }
        }
    }
    
    //MARK: - Custom Transitions
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return customNavigationAnimationController
    }
    
    
    func updateViews() {
        
        
        topNavBarBackgroundView.backgroundColor = Colors.navbarGray
        talkUpSearchTextField.backgroundColor = Colors.buttonBorderGray
        talkUpSearchTextField.borderStyle = .none
        talkUpSearchTextField.layer.cornerRadius = 8
        talkUpSearchTextField.layer.masksToBounds = true
        mainNavBottomSep.backgroundColor = Colors.buttonBorderGray
        
    }
    
    //MARK: - Filter ActionSheet
    
    func toggleFilter() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let trendingAction = UIAlertAction(title: "Trending", style: .default) { (_) in
            self.feedType = .trending
        }
        let followingAction = UIAlertAction(title: "Following", style: .default) { (_) in
            self.feedType = .following
        }
        let recentAction = UIAlertAction(title: "Recent", style: .default) { (_) in
            self.feedType = .recent
        }
        let featuredAction = UIAlertAction(title: "Featured", style: .default) { (_) in
            self.feedType = .featured
        }
        alertController.addAction(trendingAction)
        alertController.addAction(followingAction)
        alertController.addAction(recentAction)
        alertController.addAction(featuredAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true) {
            self.navBarChatFilterLabel.text = "\(self.feedType)"
            self.tableView.reloadData()
        }
    }
    
}

extension HomeViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        searchTransition.originFrame = self.view.frame
        searchTransition.presenting = true
        return searchTransition
        
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        searchTransition.presenting = false
        return searchTransition
    }
    
    
}
















