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
    
    let duration = 3.0
    var presenting = true
    var originFrame = CGRect.zero
    
    var dismissCompletion: (() -> Void)?
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let key = presenting ? UITransitionContextViewControllerKey.to : UITransitionContextViewControllerKey.from
        let controller = transitionContext.viewController(forKey: key)!
        let containerView = transitionContext.containerView
        
        if presenting {
            containerView.addSubview(controller.view)
        }
        
//        let presentedFrame = transitionContext.finalFrame(for: controller)
//        var dismissedFrame = presentedFrame
//        
//        let initialFrame = presenting ? dismissedFrame : presentedFrame
//        let finalFrame = presenting ? presentedFrame : dismissedFrame
        
        // set the initial states
        
        if let homeVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) as? HomeViewController {
            homeVC.navBarElementsTopConstraint.constant = 30
        }
        
        controller.view.alpha = 0.0
        
        UIView.animate(withDuration: duration, delay:0.0, usingSpringWithDamping: 0.4,
                       initialSpringVelocity: 0.0, animations: {
                        
                        controller.view.alpha = 1.0
                        
                        if let homeVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) as? HomeViewController {
                            homeVC.navBarElementsTopConstraint.constant = -30
                        } else if let toVC = transitionContext.viewController(forKey: .to) as? HomeViewController {
                            toVC.navBarElementsTopConstraint.constant = 30
                        }
                        
                },
                       completion:{_ in
                        if !self.presenting {
                            self.dismissCompletion?()
                    }
                    transitionContext.completeTransition(true)
        })
        
        
        
        
    }
    
}
