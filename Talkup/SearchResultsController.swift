//
//  SearchResultsController.swift
//  Talkup
//
//  Created by Andrew Ervin Gierke on 5/3/17.
//  Copyright © 2017 Androoo. All rights reserved.
//

import Foundation
import UIKit

protocol SearchResultsControllerDelegate {
    func searchTermsEntered(_ term: String)
}

class SearchResultsController: UIViewController , UISearchResultsUpdating, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchControllerDelegate, CustomSearchControllerDelegate {
    
    //MARK: - Properties
    
    var resultsArray: [SearchableRecord] = []
    var customSearchController: CustomSearchController!
    var delegate: SearchResultsControllerDelegate?
    
    @IBOutlet weak var resultsTableView: UITableView!
    
    var searchController: UISearchController?
    
    //MARK: - View Life
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isHidden = false
        navigationController?.isToolbarHidden = false
        
        resultsTableView.tableFooterView = UIView()
        
        //        setupSearchResultsController()
        configureCustomSearchController()
        
    }
    
    
    //MARK: - Tableview Datasource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "resultsCell", for: indexPath) as? ResultTableViewCell else { return ResultTableViewCell() }
        
        guard let result = resultsArray[indexPath.row] as? Chat else { return UITableViewCell() }
        
        cell.chat = result
        
        let bottomBorder = CALayer()
        bottomBorder.backgroundColor = Colors.primaryLightGray.cgColor
        bottomBorder.frame = CGRect(x: 0, y: cell.frame.size.height - 1, width: cell.frame.size.width, height: 1)
        cell.layer.addSublayer(bottomBorder)
        
        cell.separatorInset.left = 800
        
        return cell
        
    }
    
    
    //MARK: - Configure Search Controller
    
    func configureCustomSearchController() {
        
        customSearchController = CustomSearchController(searchResultsController: self, searchBarFrame: CGRect(x: 0.0, y: 0.0, width: resultsTableView.frame.width, height: 75.0), searchBarFont: UIFont(name: "ArialRoundedMTBold", size: 24.0)!, searchBarTextColor: Colors.primaryBgPurple, searchBarTintColor: UIColor.white)
        
        customSearchController.customSearchBar.placeholder = "Enter topic name                              "
        resultsTableView.tableHeaderView = customSearchController.customSearchBar
        customSearchController.customDelegate = self
    }
    
//    func setupSearchResultsController() {
//        
//        // Initialize and perform minimum configuration for search controller
//        searchController = UISearchController(searchResultsController: nil)
//        self.resultsTableView.tableHeaderView = searchController?.searchBar
//        searchController?.searchResultsUpdater = self
//        searchController?.dimsBackgroundDuringPresentation = false
//        searchController?.delegate = self
//        searchController?.searchBar.delegate = self
//        searchController?.searchBar.sizeToFit()
//        searchController?.searchBar.placeholder = "Enter topic name"
//        
//    }
    
    // cusom search delegate func s
    
    func didStartSearching() {
        resultsTableView.reloadData()
    }
    
    func didTapOnSearchButton() {
        resultsTableView.reloadData()
    }
    
    func didTapOnCancelButton() {
        resultsTableView.reloadData()
    }
    
    func didChangeSearchText(searchText: String) {
        
        let searchTerm = searchText.lowercased()
        delegate?.searchTermsEntered(searchText)
        let topics = ChatController.shared.chats
        let filteredPosts = topics.filter { $0.matches(searchTerm: searchTerm) }.map { $0 as SearchableRecord }
        self.resultsArray = filteredPosts
        self.resultsTableView.reloadData()
        
    }
    
    // default search funcs
    
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

    
    //MARK: - Navigation 
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "fromSearchToChat" {
            
            if let detailViewController = segue.destination as? ChatViewController,
                let selectedIndexPath = resultsTableView.indexPathForSelectedRow {
                
                guard let chat = resultsArray[selectedIndexPath.row] as? Chat else { return }
                
                detailViewController.navigationController?.navigationBar.isHidden = true
                chat.isDismisable = true
                detailViewController.chat = chat
                
            }
        }
    }
}










