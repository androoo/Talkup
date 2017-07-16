//
//  FadeInController.swift
//  Talkup
//
//  Created by Andrew Ervin Gierke on 7/14/17.
//  Copyright © 2017 Androoo. All rights reserved.
//

import UIKit

class FadeInController: NSObject {
    
}

extension FadeInController: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        switch operation {
        case .push:
            return FadeInPushTransition()
        case .pop:
            return FadeInPushTransition()
        default:
            return nil
        }
    }
}


