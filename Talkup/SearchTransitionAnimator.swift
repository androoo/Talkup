//
//  SearchTransitionAnimator.swift
//  Talkup
//
//  Created by Andrew Ervin Gierke on 7/14/17.
//  Copyright © 2017 Androoo. All rights reserved.
//

import UIKit

class SearchTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    let animationDuration = 0.5
    
    private var selectedCellFrame: CGRect? = nil
    private var originalTableViewY: CGFloat? = nil
    
    var fromViewController: UIViewController!
    var toViewController: UIViewController!
    var isPresenting: Bool = true
    
    init(isPresenting: Bool = true) {
        self.isPresenting = isPresenting
        super.init()
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return animationDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        
        // push to VC 
        if let homeVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) as? HomeViewController,
            let searchVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) as? MainSearchResultsViewController {
                moveFromHome(homeVC: homeVC, toSearch: searchVC, withContext: transitionContext)
        }
        
        // pop from search back home 
        
        else if let homeVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) as? HomeViewController,
            let searchVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) as? MainSearchResultsViewController {
            moveFromSearch(searchVC: searchVC, toHome: homeVC, withContext: transitionContext)
        }
    }
    
    func moveFromHome(homeVC: HomeViewController, toSearch searchVC: MainSearchResultsViewController, withContext context: UIViewControllerContextTransitioning) {
        
        context.containerView.addSubview(searchVC.view)
        homeVC.view.alpha = 0.0
        
        let imageView = createTransitionImageViewWithFrame(frame: searchVC.resultsTableView.frame)
        context.containerView.addSubview(imageView)
        
        //set up things to animate 
        
        UIView.animate(withDuration: 2.5, delay: 0.0, usingSpringWithDamping: 0.75, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            
            homeVC.view.alpha = 0.0
            homeVC.view.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            searchVC.view.alpha = 1.0
            searchVC.resultsTableView.frame.origin.y = self.originalTableViewY ?? homeVC.tableView.frame.origin.y
            imageView.alpha = 0.0
            imageView.frame = self.selectedCellFrame ?? imageView.frame
            homeVC.currentUserHeaderImageView.alpha = 1.0
            
        }) { (complete) in
            homeVC.currentUserHeaderImageView.alpha = 0.0
            homeVC.view.transform = CGAffineTransform.identity
            imageView.removeFromSuperview()
            context.completeTransition(complete)
        }
        
    }
    
    private func moveFromSearch(searchVC: MainSearchResultsViewController, toHome homeVC: HomeViewController, withContext context: UIViewControllerContextTransitioning) {
        
        context.containerView.addSubview(homeVC.view)
        searchVC.view.alpha = 0.0
        let imageView = createTransitionImageViewWithFrame(frame: homeVC.tableView.frame)
        context.containerView.addSubview(imageView)
        homeVC.currentUserHeaderImageView.alpha = 0.0
        
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 0.75, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            
            searchVC.view.alpha = 0.0
            searchVC.view.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            imageView.alpha = 0.0
            homeVC.view.alpha = 1.0
            imageView.frame = self.selectedCellFrame ?? imageView.frame
            
            homeVC.currentUserHeaderImageView.alpha = 0.0
            
        }) { (complete) in
            
            homeVC.currentUserHeaderImageView.alpha = 1.0
            searchVC.view.transform = CGAffineTransform.identity
            imageView.removeFromSuperview()
            context.completeTransition(complete)
        }
        
        
    }
    
    private func createTransitionImageViewWithFrame(frame: CGRect) -> UIImageView {
        let imageView = UIImageView(frame: frame)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }

}












