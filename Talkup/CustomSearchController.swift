//
//  CustomSearchController.swift
//  Talkup
//
//  Created by Andrew Ervin Gierke on 5/4/17.
//  Copyright © 2017 Androoo. All rights reserved.
//

import UIKit

protocol CustomSearchControllerDelegate {
    func didStartSearching()
    func didTapOnSearchButton()
    func didTapOnCancelButton()
    func didChangeSearchText(searchText: String)
}

class CustomSearchController: UISearchController, UISearchBarDelegate {
    

    //MARK: - Properties 
    
    var customSearchBar: CustomSearchBar!
    var customDelegate: CustomSearchControllerDelegate?
    
    //MARK: - Initializers
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(searchResultsController: UIViewController!, searchBarFrame: CGRect, searchBarFont: UIFont, searchBarTextColor: UIColor, searchBarTintColor: UIColor) {
        super.init(searchResultsController: searchResultsController)
        
        configureSearchBar(frame: searchBarFrame, font: searchBarFont, textColor: searchBarTextColor, bgColor: searchBarTintColor)
    }
    
    func configureSearchBar(frame: CGRect, font: UIFont, textColor: UIColor, bgColor: UIColor) {
        customSearchBar = CustomSearchBar(frame: frame, font: font , textColor: textColor)
        
        customSearchBar.barTintColor = bgColor
        customSearchBar.tintColor = textColor
        
        customSearchBar.showsBookmarkButton = false
        customSearchBar.showsCancelButton = false
        customSearchBar.showsSearchResultsButton = false
        
        customSearchBar.delegate = self
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        customDelegate?.didStartSearching()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        customSearchBar.resignFirstResponder()
        customDelegate?.didTapOnSearchButton()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        customSearchBar.resignFirstResponder()
        customDelegate?.didTapOnCancelButton()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        customDelegate?.didChangeSearchText(searchText: searchText)
    }
}
