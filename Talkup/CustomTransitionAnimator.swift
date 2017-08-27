//
//  CustomTransitionAnimator.swift
//  Talkup
//
//  Created by Andrew Ervin Gierke on 8/21/17.
//  Copyright © 2017 Androoo. All rights reserved.
//

import UIKit

class CustomTransitionAnimator: NSObject {
    
    var presenting: Bool
    var navbarHeight: Int
    
    init(presenting: Bool, navbarHeight: Int) {
        self.presenting = presenting
        self.navbarHeight = navbarHeight
        super.init()
    }
}

extension CustomTransitionAnimator: UIViewControllerAnimatedTransitioning {

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.4
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let presentingViewControllerKey = presenting ? UITransitionContextViewControllerKey.from : UITransitionContextViewControllerKey.to
        let presentedViewControllerKey = !presenting ? UITransitionContextViewControllerKey.from : UITransitionContextViewControllerKey.to
        
        let presentingViewController = transitionContext.viewController(forKey: presentingViewControllerKey)
        let presentedViewController = transitionContext.viewController(forKey: presentedViewControllerKey)
        
        let containerView = transitionContext.containerView
        
        // add a shadow to the presented view controller 
        presentedViewController?.view.layer.shadowRadius = 5
        presentedViewController?.view.layer.shadowOpacity = 0.4
        
        // the presented view controller slides totally on or off the screen from the right 
        
        var modalInitialFrame = containerView.frame
        
        //create separate snapshot of navbar using initial modalview
        var navigationBarInitialFrame = modalInitialFrame
        
        // need to set this height depending on if I want the navbar to be present in the presenting VC
        navigationBarInitialFrame.size.height = CGFloat(navbarHeight)
        
        let navigationBarSnapshot = presentingViewController?.view.resizableSnapshotView(from: navigationBarInitialFrame, afterScreenUpdates: true, withCapInsets: UIEdgeInsets.zero)
        
        var contentInitialFrame = modalInitialFrame
        contentInitialFrame.origin.y = navigationBarInitialFrame.height
        contentInitialFrame.size.height -= contentInitialFrame.minY
        
        let contentSnapshot = presentingViewController?.view.resizableSnapshotView(from: contentInitialFrame, afterScreenUpdates: true, withCapInsets: UIEdgeInsets.zero)
        
        var modalFinalFrame = modalInitialFrame
        var navigationBarFinalFrame = navigationBarInitialFrame
        var contentFinalFrame = contentInitialFrame
        
        let animationDuration = transitionDuration(using: transitionContext)
        
        if presenting {
            
            modalInitialFrame.origin.x += modalInitialFrame.width
            navigationBarFinalFrame.origin.x -= navigationBarFinalFrame.width
            contentFinalFrame.origin.x -= contentFinalFrame.width / 3.0
            
            containerView.insertSubview(contentSnapshot!, aboveSubview: (presentedViewController?.view)!)
            containerView.insertSubview((presentedViewController?.view)!, aboveSubview: contentSnapshot!)
            containerView.insertSubview(navigationBarSnapshot!, aboveSubview: (presentingViewController?.view)!)
            
        } else {
            
            modalFinalFrame.origin.x += modalFinalFrame.width
            navigationBarInitialFrame.origin.x -= navigationBarInitialFrame.width
            contentInitialFrame.origin.x -= contentInitialFrame.width / 3.0
            
            containerView.insertSubview(navigationBarSnapshot!, aboveSubview: (presentedViewController?.view)!)
            containerView.insertSubview(contentSnapshot!, belowSubview: (presentedViewController?.view)!)
            
        }
        
        presentedViewController?.view.frame = modalInitialFrame
        navigationBarSnapshot?.frame = navigationBarInitialFrame
        contentSnapshot?.frame = contentInitialFrame
        
        presentingViewController?.view.alpha = 0
        
        UIView.animate(withDuration: animationDuration, animations: {
        
            presentedViewController?.view.frame = modalFinalFrame
            navigationBarSnapshot?.frame = navigationBarFinalFrame
            contentSnapshot?.frame = contentFinalFrame
            contentSnapshot?.layer.opacity = 0.9
            
        }) { (finished) in
        
            presentingViewController?.view.alpha = 1
            navigationBarSnapshot?.removeFromSuperview()
            contentSnapshot?.removeFromSuperview()
            
            presentedViewController?.view.layer.shadowOpacity = 0
            
            let cancelled = transitionContext.transitionWasCancelled
            
//            if !cancelled {
//                presentedViewController?.view.removeFromSuperview()
//            }
            
            transitionContext.completeTransition(finished)
            
        }
    }
}













