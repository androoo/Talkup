//
//  SlideMenuAnimator.swift
//  Talkup
//
//  Created by Andrew Ervin Gierke on 7/18/17.
//  Copyright © 2017 Androoo. All rights reserved.
//

import UIKit

class SlideMenuAnimator: NSObject {

    //MARK: - Properties 
    
    var direction: PresentationDirection
    var isPresentation: Bool
    
    init(direction: PresentationDirection, isPresentation: Bool) {
        
        self.direction = direction
        self.isPresentation = isPresentation
        super.init()
        
    }
}

extension SlideMenuAnimator: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let key = isPresentation ? UITransitionContextViewControllerKey.to : UITransitionContextViewControllerKey.from
        
        let controller = transitionContext.viewController(forKey: key)!
        
        if isPresentation {
            transitionContext.containerView.addSubview(controller.view)
        }
        
        let presentedFrame = transitionContext.finalFrame(for: controller)
        var dismissedFrame = presentedFrame
        
        switch direction {
        case .left:
            dismissedFrame.origin.x = -presentedFrame.width
        case .right:
            dismissedFrame.origin.x = transitionContext.containerView.frame.size.width
        case .top:
            dismissedFrame.origin.y = -presentedFrame.height
        case .bottom:
            dismissedFrame.origin.y = transitionContext.containerView.frame.size.height
        }
        
        let initialFrame = isPresentation ? dismissedFrame : presentedFrame
        let finalFrame = isPresentation ? presentedFrame : dismissedFrame
        
        let animationDuration = transitionDuration(using: transitionContext)
        controller.view.frame = initialFrame
        UIView.animate(withDuration: animationDuration, animations: { 
            controller.view.frame = finalFrame
        }) { (finished) in
            transitionContext.completeTransition(finished)
        }
    }
}





