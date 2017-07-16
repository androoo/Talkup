//
//  MainSearchController.swift
//  Talkup
//
//  Created by Andrew Ervin Gierke on 7/12/17.
//  Copyright © 2017 Androoo. All rights reserved.
//

import UIKit

protocol MainSearchControllerDelegate {
    func didStartSearching()
    func didTapOnSearchButton()
    func didTapOnCancelButton()
    func didChangeSearchText(searchText: String)
}

class MainSearchController: UISearchController, UISearchBarDelegate {
    
    //MARK: - Properties 
    
    static let mainSearchBarWasSetNotification = Notification.Name("mainSearchBarWasSet")
    
    var mainSearchBar: MainSearchBar!
    var searchDelegate: MainSearchControllerDelegate?

    
    //MARK: - Initializers 
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    
    init(searchResultsController: UIViewController, searchBarFrame: CGRect, searchBarFont: UIFont, searchBarTextColor: UIColor, searchBarTintColor: UIColor) {
    
        super.init(searchResultsController: searchResultsController)
        
        configureSearchBar(frame: searchBarFrame, font: searchBarFont, textColor: searchBarTextColor, bgColor: searchBarTintColor)
        
    }
    
    func configureSearchBar(frame: CGRect, font: UIFont, textColor: UIColor, bgColor: UIColor) {
        mainSearchBar = MainSearchBar(frame: frame, font: font, textColor: textColor)
        mainSearchBar.barTintColor = bgColor
        mainSearchBar.tintColor = textColor
        mainSearchBar.showsBookmarkButton = false
        mainSearchBar.showsCancelButton = true
        mainSearchBar.showsSearchResultsButton = false
        mainSearchBar.delegate = self
    
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchDelegate?.didStartSearching()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchDelegate?.didTapOnSearchButton()
        mainSearchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        mainSearchBar.resignFirstResponder()
        searchDelegate?.didTapOnCancelButton()
        _ = navigationController?.popViewController(animated: true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchDelegate?.didChangeSearchText(searchText: searchText)
    }
}







