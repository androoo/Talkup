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
    
    //Navbar animation properties
    let maxHeaderHeight: CGFloat = 145
    let minHeaderHeight: CGFloat = 74
    
    var previousScrollOffset: CGFloat = 0
    
    // Search Bar stuff
    var searchBar: UISearchBar?
    var searchController: UISearchController!
    @IBOutlet weak var navBarElementsTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var mainSearchToNavBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var mainSearchTrailingConstraint: NSLayoutConstraint!
    
    var feedType: FeedFilter = .trending
    
    var chats: [Chat] {
        switch feedType {
        case .trending:
            return ChatController.shared.chats
        case .following:
            return ChatController.shared.followingChats
        case .recent:
            return ChatController.shared.recentChats
        case .featured:
            return ChatController.shared.chats
        }
    }
    
    //VC transitions
    let slideAnimator = SearchTransitionAnimator()
    let customNavigationAnimationController = SearchTransitionAnimator()
    lazy var slideInMenuTransitioningDelegate = SlideMenuTransitionController()
    let searchTransition = SearchbarAnimator()
    
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
    @IBOutlet weak var headerHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var searchIconImageView: UIImageView!


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
        toggleFilter {
            self.tableView.reloadData()
        }
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
        
        // need to make sure none of these are empty and decide what to load first
        
        switch feedType {
        case .following:
            return ChatController.shared.followingChats.count
        case .trending:
            return ChatController.shared.chats.count
        case .recent:
            return ChatController.shared.chats.count
        case .featured:
            return ChatController.shared.chats.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch feedType {
            
        case .following:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "followChat", for: indexPath) as? FollowingChatTableViewCell else { return
                FollowingChatTableViewCell()
            }
            
            let chat = self.chats[indexPath.row]
            cell.chat = chat
            let customSelectedView = UIView()
            customSelectedView.backgroundColor = Colors.primaryLightGray
            cell.selectedBackgroundView = customSelectedView
            
            return cell
            
        case .trending:
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "chatCell", for: indexPath) as? ChatTableViewCell else { return ChatTableViewCell() }
            
            let chat = self.chats[indexPath.row]
            cell.chat = chat
            cell.chatRankLabel.text = "\(indexPath.row + 1)"
            
            let customSelectedView = UIView()
            customSelectedView.backgroundColor = Colors.primaryLightGray
            cell.selectedBackgroundView = customSelectedView
            
            return cell
            
        case .recent:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "recentCell", for: indexPath) as? RecentChatTableViewCell else { return RecentChatTableViewCell() }
            
            let chat = self.chats[indexPath.row]
            cell.chat = chat
            
            let customSelectedView = UIView()
            customSelectedView.backgroundColor = Colors.primaryLightGray
            cell.selectedBackgroundView = customSelectedView
            
            return cell
            
        case .featured:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "chatCell", for: indexPath) as? ChatTableViewCell else { return ChatTableViewCell() }
            
            let chat = self.chats[indexPath.row]
            cell.chat = chat
            cell.chatRankLabel.text = "\(indexPath.row + 1)"
            
            let customSelectedView = UIView()
            customSelectedView.backgroundColor = Colors.primaryLightGray
            cell.selectedBackgroundView = customSelectedView
            
            return cell
            
        }
        
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
    
    func toggleFilter(completion: @escaping () -> Void) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let trendingAction = UIAlertAction(title: "Trending", style: .default) { (_) in
            self.feedType = .trending
            self.navBarChatFilterLabel.text = "Trending"
            completion()
        }
        let followingAction = UIAlertAction(title: "Following", style: .default) { (_) in
            self.feedType = .following
            self.navBarChatFilterLabel.text = "Following"
            completion()
        }
        let recentAction = UIAlertAction(title: "Recent", style: .default) { (_) in
            self.feedType = .recent
            self.navBarChatFilterLabel.text = "Recent"
            completion()
        }
//        let featuredAction = UIAlertAction(title: "Featured", style: .default) { (_) in
//            self.feedType = .featured
//            completion()
//        }
        alertController.addAction(trendingAction)
        alertController.addAction(followingAction)
        alertController.addAction(recentAction)
//        alertController.addAction(featuredAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true) {
            // do anything when controller is presented
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

extension HomeViewController {
    
    
    
    //MARK: - Navigation bar animation
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let scrollDiff = scrollView.contentOffset.y - self.previousScrollOffset
        
        let absoluteTop: CGFloat = 0;
        let absoluteBottom: CGFloat = scrollView.contentSize.height - scrollView.frame.size.height;
        
        let isScrollingDown = scrollDiff > 0 && scrollView.contentOffset.y > absoluteTop
        let isScrollingUp = scrollDiff < 0 && scrollView.contentOffset.y < absoluteBottom
        
        if canAnimateHeader(scrollView) {
            
            // Calculate new header height
            var newHeight = self.headerHeightConstraint.constant
            if isScrollingDown {
                newHeight = max(self.minHeaderHeight, self.headerHeightConstraint.constant - abs(scrollDiff))
                
            } else if isScrollingUp {
                newHeight = min(self.maxHeaderHeight, self.headerHeightConstraint.constant + abs(scrollDiff))
                
            }
            
            // Header needs to animate
            if newHeight != self.headerHeightConstraint.constant {
                self.headerHeightConstraint.constant = newHeight
                self.updateHeader()
                self.setScrollPosition(self.previousScrollOffset)
            }
            
            self.previousScrollOffset = scrollView.contentOffset.y
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.scrollViewDidStopScrolling()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            self.scrollViewDidStopScrolling()
        }
    }
    
    func scrollViewDidStopScrolling() {
        let range = self.maxHeaderHeight - self.minHeaderHeight
        let midPoint = self.minHeaderHeight + (range / 2)
        
        if self.headerHeightConstraint.constant > midPoint {
            self.expandHeader()
        } else {
            self.collapseHeader()
        }
    }
    
    
    func canAnimateHeader(_ scrollView: UIScrollView) -> Bool {
        // Calculate the size of the scrollView when header is collapsed
        let scrollViewMaxHeight = scrollView.frame.height + self.headerHeightConstraint.constant - minHeaderHeight
        
        // Make sure that when header is collapsed, there is still room to scroll
        return scrollView.contentSize.height > scrollViewMaxHeight
    }
    
    func collapseHeader() {
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.2, animations: {
            self.headerHeightConstraint.constant = self.minHeaderHeight
            self.updateHeader()
            self.view.layoutIfNeeded()
        })
    }
    
    func expandHeader() {
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.2, animations: {
            self.headerHeightConstraint.constant = self.maxHeaderHeight
            self.updateHeader()
            self.view.layoutIfNeeded()
        })
    }
    
    func setScrollPosition(_ position: CGFloat) {
        self.tableView.contentOffset = CGPoint(x: self.tableView.contentOffset.x, y: position)
    }
    
    func updateHeader() {
        let range = self.maxHeaderHeight - self.minHeaderHeight
        let openAmount = self.headerHeightConstraint.constant - self.minHeaderHeight
        let percentage = openAmount / range
        self.talkUpSearchTextField.alpha = percentage
        self.searchIconImageView.alpha = percentage
    }
    
}















