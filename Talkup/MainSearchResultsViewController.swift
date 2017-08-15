//
//  MainSearchResultsViewController.swift
//  Talkup
//
//  Created by Andrew Ervin Gierke on 7/12/17.
//  Copyright © 2017 Androoo. All rights reserved.
//

import UIKit

class MainSearchResultsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating, UISearchBarDelegate, UISearchControllerDelegate, MainSearchControllerDelegate, UIViewControllerTransitioningDelegate, UITextFieldDelegate {
    
    //MARK: - Properties 
    
    @IBOutlet weak var mainNavbar: UIView!
    @IBOutlet weak var tableViewOverlayView: UIView!
    @IBOutlet weak var searchBarTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var resultsTableView: UITableView!
    
    @IBOutlet weak var searchResultsTextField: SearchCustomTextField!
    @IBOutlet weak var searchBarTrailingConstraint: NSLayoutConstraint!
    
    var resultsArray: [SearchableRecord] = [] {
        didSet {
            tableViewOverlayView.isHidden = true
            resultsTableView.isHidden = false
            resultsTableView.reloadData()
            // turn on tableview
            // update the shits
        }
    }
    
    var delegate: MainSearchControllerDelegate?
    var mainSearchController: MainSearchController!
    var searchController: UISearchController?
    
    var searchTerm: String?
    
    //MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        tableViewOverlayView.backgroundColor = .black
        tableViewOverlayView.alpha = 0.5
        navigationController?.navigationBar.isHidden = true
        navigationController?.isToolbarHidden = true
        resultsTableView.isHidden = true
        searchResultsTextField.delegate = self
        searchResultsTextField.backgroundColor = Colors.buttonBorderGray
        searchResultsTextField.borderStyle = .none
        searchResultsTextField.layer.cornerRadius = 8
        searchResultsTextField.layer.masksToBounds = true
        searchResultsTextField.addTarget(self, action: #selector(textIsChanging(textfield:)), for: .editingChanged)
        tableViewOverlayView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(actionClose(_:))))
    }
    
    //MARK: - UI Actions 
    
    @IBAction func cancelButtonWasTapped(_ sender: Any) {
        presentingViewController?.dismiss(animated: true, completion: nil)
        
    }
    
    func actionClose(_ tap: UITapGestureRecognizer) {
        presentingViewController?.dismiss(animated: true, completion: nil)
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
    
    func setupSearchBar() {
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
                    
                    subsubView.layoutSubviews()
                }
            }
        }
    }
    
    //MARK: - Configure Search Controller 
    
    func configureMainSearchController(completion: @escaping (MainSearchBar) -> Void) {
        
        mainSearchController = MainSearchController(searchResultsController: self, searchBarFrame: CGRect(x: 0.0, y: 0.0, width: Double(self.view.frame.width), height: 75.0), searchBarFont: UIFont(name: "Helvetica", size: 18.0)!, searchBarTextColor: Colors.primaryBgPurple, searchBarTintColor: .white)
        
        mainSearchController.mainSearchBar.placeholder = "Search Talkup"
//        mainNavbar.addSubview(mainSearchController.mainSearchBar)
        setupSearchBar()
        mainSearchController.searchDelegate = self
        
    }
    
    func setupMainSearchResultsController() {
        
    }
    
    //MARK: - TextField search 
    
    func textIsChanging(textfield: UITextField) {
        searchTerm = textfield.text
        
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        // triggers the return 
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let searchTerm = textField.text?.lowercased() else { return false }
        let topics = ChatController.shared.chats
        let filteredPosts = topics.filter { $0.matches(searchTerm: searchTerm) }.map { $0 as SearchableRecord }
        self.resultsArray = filteredPosts
        self.resultsTableView.reloadData()
        
        return true
    }

    //MARK: - Custom Main Search Delegation 
    
    func didStartSearching() {
        resultsTableView.reloadData()
    }
    
    func didTapOnSearchButton() {
        resultsTableView.reloadData()
    }
    
    func didTapOnCancelButton() {
        
    }
    
    func didChangeSearchText(searchText: String) {
        let searchTerm = searchText.lowercased()
        self.searchTerm = searchTerm
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
}















