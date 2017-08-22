//
//  CustomPushTransitionController.swift
//  Talkup
//
//  Created by Andrew Ervin Gierke on 8/21/17.
//  Copyright © 2017 Androoo. All rights reserved.
//

import UIKit

class CustomPushTransitionController: NSObject {
    
    
}

extension CustomPushTransitionController: UIViewControllerTransitioningDelegate {
    
    func presentationController(forPresented presented: UIViewController,
                                presenting: UIViewController?,
                                source: UIViewController) -> UIPresentationController? {
        
        let presentationController = CustomTransitionController(presentedViewController: presented, presenting: presenting)
        
        return presentationController
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return CustomTransitionAnimator(presenting: true)
        
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CustomTransitionAnimator(presenting: false)
    }
    
}
