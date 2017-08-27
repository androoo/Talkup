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
        
        // I only animate one VC depening on if im presenting or not, so i need ot add animation for the other one
        let mainKey = isPresentation ? UITransitionContextViewControllerKey.to : UITransitionContextViewControllerKey.from
        
        // opposite view for the VC
        let secondaryKey = !isPresentation ? UITransitionContextViewControllerKey.to : UITransitionContextViewControllerKey.from
        
        let menuController = transitionContext.viewController(forKey: mainKey)!
        
        guard let startController = transitionContext.viewController(forKey: secondaryKey)! as? UINavigationController else { return }
        
        let homeController = startController.viewControllers.first!
        
        if isPresentation {
            
            transitionContext.containerView.addSubview(menuController.view)
//            transitionContext.containerView.insertSubview(homeController.view, belowSubview: menuController.view)
//            transitionContext.containerView.addSubview(homeController.view)

        } else {
//            transitionContext.containerView.addSubview(homeController.view)
        }
        
        let presentedFrame = transitionContext.finalFrame(for: menuController)
        var dismissedFrame = presentedFrame
        
        let originalHomeFrame = transitionContext.initialFrame(for: startController)
        let homeFinalFrame = transitionContext.finalFrame(for: startController)
        var originalHomeFrameOpen = originalHomeFrame
        
//        var oldFrame = transitionContext.initialFrame(for: dismissedController)
        
        switch direction {
        case .left:
            dismissedFrame.origin.x = -presentedFrame.width
            originalHomeFrameOpen.origin.x = presentedFrame.width
        case .right:
            dismissedFrame.origin.x = transitionContext.containerView.frame.size.width
        case .top:
            dismissedFrame.origin.y = -presentedFrame.height
        case .bottom:
            dismissedFrame.origin.y = transitionContext.containerView.frame.size.height
        }
        
        //depending on presentatoin, intial frame is either
        
        let initialFrame = isPresentation ? dismissedFrame : presentedFrame
        let finalFrame = isPresentation ? presentedFrame : dismissedFrame
        
        let homeInitialFrame = isPresentation ? originalHomeFrame : originalHomeFrameOpen
        let homeOpenFrame = isPresentation ? originalHomeFrameOpen : homeFinalFrame
        
        let animationDuration = transitionDuration(using: transitionContext)
        
        menuController.view.frame = initialFrame
        homeController.view.frame = homeInitialFrame
        
        UIView.animate(withDuration: animationDuration, animations: {
            
            menuController.view.frame = finalFrame
            homeController.view.frame = homeOpenFrame
            
        }) { (finished) in
            transitionContext.completeTransition(finished)
        }
    }
}





