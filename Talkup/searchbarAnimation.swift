//
//  searchbarAnimation.swift
//  Talkup
//
//  Created by Andrew Ervin Gierke on 8/13/17.
//  Copyright © 2017 Androoo. All rights reserved.
//

import Foundation
import UIKit

class SearchbarAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    let duration = 0.3
    var presenting = true
    var originFrame = CGRect.zero
    
    var dismissCompletion: (() -> Void)?
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        // gets the relevant key
        let key = presenting ? UITransitionContextViewControllerKey.to : UITransitionContextViewControllerKey.from
        
        // sets the active transition context VC
        let controller = transitionContext.viewController(forKey: key)!
        
        // sets the active animation container
        let containerView = transitionContext.containerView
        
        // if it is presenting it adds the to view to the container
        if presenting {
            containerView.addSubview(controller.view)
        }
        
        // set the presented and dismissed frames. This only helps with positioning for VC movements
        let presentedFrame = transitionContext.finalFrame(for: controller)
        let dismissedFrame = presentedFrame
        
        let initialFrame = presenting ? dismissedFrame : presentedFrame
        let finalFrame = presenting ? presentedFrame : dismissedFrame
        
        let initialAlpha = presenting ? 0.0 : 1.0
        let finalAlpha = presenting ? 1.0 : 0.0

        // need to edit constraints on the VCs
        
        //if it is presenting, initialVC is HOME and final is Search. If it is not presenting initial is Search and Final is Home
        
        // set the initial states
        
        let initialViewController = presenting ? transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) as? HomeViewController : transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) as? MainSearchResultsViewController
        
        let finalViewController = presenting ? transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) as? MainSearchResultsViewController : transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) as? HomeViewController
        
        if let initialVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) as? HomeViewController {
            initialVC.navBarElementsTopConstraint.constant = 30.0
            initialVC.mainSearchToNavBottomConstraint.constant = 30.0
            initialVC.mainSearchTrailingConstraint.constant = 22.0
        }
        
        controller.view.alpha = CGFloat(initialAlpha)
        
        UIView.animate(withDuration: duration, animations: {
            
            if let dismissedVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) as? HomeViewController {
                dismissedVC.navBarElementsTopConstraint.constant = -40.0
                dismissedVC.mainSearchToNavBottomConstraint.constant = 74.0
                dismissedVC.mainSearchTrailingConstraint.constant = 96.0
                initialViewController?.view.layoutIfNeeded()
                
            }
            
            if let finalVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) as? HomeViewController {
                finalVC.navBarElementsTopConstraint.constant = 30.0
                finalVC.mainSearchTrailingConstraint.constant = 22.0
                finalVC.mainSearchToNavBottomConstraint.constant = 18.0
                finalVC.view.layoutIfNeeded()
            }
            
        }, completion: { _ in
            
            if !self.presenting {
                self.dismissCompletion!()
            }
            
            controller.view.alpha = CGFloat(finalAlpha)
            
            transitionContext.completeTransition(true)
        })
        
        
    }
}
