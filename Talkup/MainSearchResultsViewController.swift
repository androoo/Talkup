//
//  MainSearchResultsViewController.swift
//  Talkup
//
//  Created by Andrew Ervin Gierke on 7/12/17.
//  Copyright © 2017 Androoo. All rights reserved.
//

import UIKit

class MainSearchResultsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating, UISearchBarDelegate, UISearchControllerDelegate, MainSearchControllerDelegate, UINavigationControllerDelegate {
    
    //MARK: - Properties 
    
    
    @IBOutlet weak var mainNavbar: UIView!
    
    @IBOutlet weak var resultsTableView: UITableView!
    
    var resultsArray: [SearchableRecord] = []
    var delegate: MainSearchControllerDelegate?
    var mainSearchController: MainSearchController!
    var searchController: UISearchController?
    
    //VC transitions
    let slideAnimator = SearchTransitionAnimator()
    let customNavigationAnimationController = SearchTransitionAnimator()
    
    //MARK: - View Lifecycle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        navigationController?.isToolbarHidden = true
//        resultsTableView.tableFooterView = UIView()
        configureMainSearchController()
        self.navigationController?.navigationBar.isHidden = true
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        for subView in mainSearchController.mainSearchBar.subviews  {
            for subsubView in subView.subviews  {
                if let textField = subsubView as? UITextField {
                    var bounds: CGRect
                    bounds = textField.frame
                    bounds.size.height = 35 //(set height to whatever)
                    textField.bounds = bounds
                    textField.borderStyle = UITextBorderStyle.roundedRect
                    textField.backgroundColor = Colors.primaryLightGray
                    textField.layer.cornerRadius = 10.0
                    textField.layer.frame = CGRect(x: 16.0, y: 30.0, width: bounds.size.width - 8.0, height: 35.0)
                }
            }
        }
    }
    
    //MARK: - TableViewDataSource Methods 
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return resultsArray.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "mainResultsCell", for: indexPath) as? SearchResultTableViewCell,
            let result = resultsArray[indexPath.row] as? Chat else { return SearchResultTableViewCell() }
        
        cell.chat = result
        return cell 
    }
    
    //MARK: - Configure Search Controller 
    
    func configureMainSearchController() {
        
        mainSearchController = MainSearchController(searchResultsController: self, searchBarFrame: CGRect(x: 0.0, y: 0.0, width: Double(self.view.frame.width), height: 75.0), searchBarFont: UIFont(name: "Helvetica", size: 18.0)!, searchBarTextColor: Colors.primaryBgPurple, searchBarTintColor: .white)
        
        mainSearchController.mainSearchBar.placeholder = "Search Talkup"
//        resultsTableView.tableHeaderView = mainSearchController.mainSearchBar
        mainNavbar.addSubview(mainSearchController.mainSearchBar)
        mainSearchController.searchDelegate = self
        
    }
    
    func setupMainSearchResultsController() {
    }
    

    //MARK: - Custom Main Search Delegation 
    
    func didStartSearching() {
        resultsTableView.reloadData()
    }
    
    func didTapOnSearchButton() {
        resultsTableView.reloadData()
    }
    
    func didTapOnCancelButton() {
        navigationController?.delegate = self
        _ = navigationController?.popViewController(animated: true)
    }
    
    func didChangeSearchText(searchText: String) {
        let searchTerm = searchText.lowercased()
        let topics = ChatController.shared.chats
        let filteredPosts = topics.filter { $0.matches(searchTerm: searchTerm) }.map { $0 as SearchableRecord }
        self.resultsArray = filteredPosts
        self.resultsTableView.reloadData()
        
    }
    
    
    //MARK: - Default Search Delegation/Datasource 
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        resultsTableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        resultsTableView.reloadData()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        
        if let searchTerm = searchController.searchBar.text?.lowercased() {
            let chats = ChatController.shared.chats
            let filteredPosts = chats.filter { $0.matches(searchTerm: searchTerm) }.map { $0 as SearchableRecord }
            
            self.resultsArray = filteredPosts
            self.resultsTableView.reloadData()
        }
        
    }
    
    //MARK: - Prepare for segue nav
    
    
    //MARK: - Custom Transitions
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return customNavigationAnimationController
    }
    
}















