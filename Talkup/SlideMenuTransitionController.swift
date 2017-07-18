//
//  SlideMenuTransitionController.swift
//  Talkup
//
//  Created by Andrew Ervin Gierke on 7/18/17.
//  Copyright © 2017 Androoo. All rights reserved.
//

import UIKit

enum PresentationDirection {
    case left, top, right, bottom
}

class SlideMenuTransitionController: NSObject {

    var direction = PresentationDirection.left
    
}

extension SlideMenuTransitionController: UIViewControllerTransitioningDelegate {
    
    func presentationController(forPresented presented: UIViewController,
                                presenting: UIViewController?,
                                source: UIViewController) -> UIPresentationController? {
        
        let presentationController = SlideMenuController(presentedViewController: presented,
                                                                   presenting: presenting,
                                                                   direction: direction)
        return presentationController
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return SlideMenuAnimator(direction: direction, isPresentation: true)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return SlideMenuAnimator(direction: direction, isPresentation: false)
    }
    
}
