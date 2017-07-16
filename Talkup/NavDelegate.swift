//
//  NavDelegate.swift
//  Talkup
//
//  Created by Andrew Ervin Gierke on 7/15/17.
//  Copyright © 2017 Androoo. All rights reserved.
//

import UIKit

class NavDelegate: NSObject, UINavigationControllerDelegate {

    private let animator = SearchTransitionAnimator()
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return animator
    }
    
}
