//
//  CustomTransitionController.swift
//  Talkup
//
//  Created by Andrew Ervin Gierke on 8/21/17.
//  Copyright © 2017 Androoo. All rights reserved.
//

import UIKit

class CustomTransitionController: UIPresentationController {
    
    let navigationController = UINavigationController()
    var interactionController = UIPercentDrivenInteractiveTransition()
    
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        
        let panGestureRecognizer = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handlePan(gestureRecognizer:)))
        
        navigationController.view.addGestureRecognizer(panGestureRecognizer)
    }
    
}

private extension CustomTransitionController {
    
    @objc func handlePan(gestureRecognizer: UIScreenEdgePanGestureRecognizer) {
        
        let view = self.navigationController.view
        
        if (gestureRecognizer.state == UIGestureRecognizerState.began) {
            
            self.interactionController = UIPercentDrivenInteractiveTransition()
            self.navigationController.dismiss(animated: true, completion: nil)
            
        } else if (gestureRecognizer.state == UIGestureRecognizerState.changed) {
            
            let percent = gestureRecognizer.translation(in: view).x / (view?.bounds.width)!
            interactionController.update(percent)
            
        } else if (gestureRecognizer.state == UIGestureRecognizerState.ended) {
            
            let percent = gestureRecognizer.translation(in: view).x / (view?.bounds.width)!
            if (percent > 0.5 || gestureRecognizer.velocity(in: view).x > 50 ) {
                self.interactionController.finish()
            } else {
                self.interactionController.cancel()
            }
            print("might need to do something here")
        }
    }
}

