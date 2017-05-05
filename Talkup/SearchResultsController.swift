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
        
        self.navigationController?.navigationBar.isHidden = false
        
        //        setupSearchResultsController()
        configureCustomSearchController()
    }
    
    
    //MARK: - Tableview Datasource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "resultsCell", for: indexPath)
        
        guard let result = resultsArray[indexPath.row] as? Chat else { return UITableViewCell() }
        
        cell.textLabel?.text = result.topic
        
        return cell
        
    }
    
    
    //MARK: - Configure Search Controller
    
    func configureCustomSearchController() {
        
        customSearchController = CustomSearchController(searchResultsController: self, searchBarFrame: CGRect(x: 0.0, y: 0.0, width: resultsTableView.frame.width, height: 75.0), searchBarFont: UIFont(name: "ArialRoundedMTBold", size: 24.0)!, searchBarTextColor: Colors.primaryBgPurple, searchBarTintColor: UIColor.white)
        
        customSearchController.customSearchBar.placeholder = "Enter topic name                              "
        resultsTableView.tableHeaderView = customSearchController.customSearchBar
        
        customSearchController.customDelegate = self
    }
    
    func setupSearchResultsController() {
        
        // Initialize and perform minimum configuration for search controller
        searchController = UISearchController(searchResultsController: nil)
        self.resultsTableView.tableHeaderView = searchController?.searchBar
        searchController?.searchResultsUpdater = self
        searchController?.dimsBackgroundDuringPresentation = false
        searchController?.delegate = self
        searchController?.searchBar.delegate = self
        searchController?.searchBar.sizeToFit()
        
        searchController?.searchBar.placeholder = "Enter topic name"
        
    }
    
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
            
            let topics = ChatController.shared.chats
            let filteredPosts = topics.filter { $0.matches(searchTerm: searchTerm) }.map { $0 as SearchableRecord }
            
            self.resultsArray = filteredPosts
            self.resultsTableView.reloadData()
            
        }
    }
    
    //MARK: - Navigation 
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "fromSearchToChat" {
            
            if let detailViewController = segue.destination as? ChatViewController,
                let selectedIndexPath = resultsTableView.indexPathForSelectedRow {
                
                let chat = ChatController.shared.chats[selectedIndexPath.row]
                
                detailViewController.navigationController?.navigationBar.isHidden = true
                detailViewController.chat = chat
                
            }
        }
    }
}









