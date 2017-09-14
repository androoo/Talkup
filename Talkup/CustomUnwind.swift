//
//  CustomUnwind.swift
//  Talkup
//
//  Created by Andrew Ervin Gierke on 8/31/17.
//  Copyright © 2017 Androoo. All rights reserved.
//

import Foundation
import UIKit

class CustomUnwindSegue: UIStoryboardSegue {
    
    override func perform() {
        
        let toViewController: UIViewController = self.destination as! UIViewController
        let fromViewController: UIViewController = self.source as! UIViewController
        
        let containerView: UIView? = fromViewController.view.superview
        let screenBounds: CGRect = UIScreen.main.bounds
        
        let finalToFrame: CGRect = screenBounds
        let finalFromFrame: CGRect = finalToFrame.offsetBy(dx: screenBounds.size.width, dy: 0)
        
        toViewController.view.frame = finalToFrame.offsetBy(dx: -screenBounds.size.width, dy: 0)
        containerView?.addSubview(toViewController.view)
        
        UIView.animate(withDuration: 0.5, animations: {
            
            toViewController.view.frame = finalToFrame
            fromViewController.view.frame = finalFromFrame
            
        }, completion: { finished in
            let fromVC: UIViewController = self.source as! UIViewController
            let toVC: UIViewController = self.destination as! UIViewController
            fromVC.dismiss(animated: false, completion: nil)
        })
    }
}
