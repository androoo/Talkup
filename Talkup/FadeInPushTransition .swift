//
//  FadeInPushTransition .swift
//  Talkup
//
//  Created by Andrew Ervin Gierke on 7/14/17.
//  Copyright © 2017 Androoo. All rights reserved.
//

import UIKit

class FadeInPushTransition: NSObject {
    var fromViewController: UIViewController!
    var toViewController: UIViewController!
    var isPresenting: Bool = true
    
    init(isPresenting: Bool = true) {
        self.isPresenting = isPresenting
        super.init()
    }
}

extension FadeInPushTransition: UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        self.fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)
        self.toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
        
        let containerView = transitionContext.containerView
        
        let view = toViewController.view!
        let fromView = fromViewController.view!
        
        view.frame = isPresenting ? view.frame.offsetBy(dx: 75, dy: 0) : view.frame
        fromView.frame = isPresenting ? fromView.frame : fromView.frame
        let newFrameFromView = isPresenting ? fromView.frame : fromView.frame.offsetBy(dx: 75, dy: 0)
        let newFrameForView = isPresenting ? fromView.frame : view.frame
        let viewAlpha: CGFloat = isPresenting ? 1.0 : 1.0
        let fromViewAlpha: CGFloat = isPresenting ? 1.0 : 0.0
        
        view.alpha = isPresenting ? 0.0 : 1.0
        fromView.alpha = isPresenting ? 1.0 : 1.0
        
        if isPresenting {
            containerView.addSubview(fromView)
            containerView.addSubview(view)
        } else {
            containerView.addSubview(view)
            containerView.addSubview(fromView)
        }
        
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.95, initialSpringVelocity: 1.0, options: .curveEaseIn, animations: { 
            
            view.alpha = viewAlpha
            view.frame = newFrameForView
            fromView.frame = newFrameFromView
            fromView.alpha = fromViewAlpha
            
        }) { (done) in
            transitionContext.completeTransition(done)
        }
    }
    
}















