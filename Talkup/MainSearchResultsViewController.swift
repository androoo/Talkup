//
//  MainSearchResultsViewController.swift
//  Talkup
//
//  Created by Andrew Ervin Gierke on 7/12/17.
//  Copyright © 2017 Androoo. All rights reserved.
//

import UIKit

class MainSearchResultsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating, UISearchBarDelegate, UISearchControllerDelegate, MainSearchControllerDelegate {
    
    //MARK: - Properties 
    
    
    @IBOutlet weak var mainNavbar: UIView!
    
    @IBOutlet weak var resultsTableView: UITableView!
    
    var resultsArray: [SearchableRecord] = []
    var delegate: MainSearchControllerDelegate?
    var mainSearchController: MainSearchController!
    var searchController: UISearchController?
    
    //MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = false
        navigationController?.isToolbarHidden = false
        resultsTableView.tableFooterView = UIView()
        configureMainSearchController()
        self.navigationController?.navigationBar.isHidden = true
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
        
        mainSearchController = MainSearchController(searchResultsController: self, searchBarFrame: CGRect(x: 0.0, y: 0.0, width: 375.0, height: 75.0), searchBarFont: UIFont(name: "helvetica", size: 18.0)!, searchBarTextColor: Colors.primaryBgPurple, searchBarTintColor: .white)
        
        mainSearchController.mainSearchBar.placeholder = "Search Talkup"
        mainNavbar.addSubview(mainSearchController.mainSearchBar)
        mainSearchController.searchDelegate = self
        
    }
    
    func setupMainSearchResultsController() {
    }
    

    //MARK: - Custom Main Search Delegation 
    
    func didStartSearching() {
        
    }
    
    func didTapOnSearchButton() {
        
    }
    
    func didTapOnCancelButton() {
        _ = navigationController?.popViewController(animated: true)
    }
    
    func didChangeSearchText(searchText: String) {
        
    }
    
    
    //MARK: - Default Search Delegation/Datasource 
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        
        
        
    }
    
    //MARK: - Prepare for segue nav
    
}















