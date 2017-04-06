//
//  PageViewController.swift
//  Talkup
//
//  Created by Andrew Ervin Gierke on 4/3/17.
//  Copyright © 2017 Androoo. All rights reserved.
//

import UIKit

class PageViewController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource, UIScrollViewDelegate {
    
    //MARK: - Properties
    var pageControl = UIPageControl()
    private(set) lazy var orderedViewControllers: [UIViewController] = []
    
    //MARK: - Page ViewController Datasource
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
    }
    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return nil
        }
        
        guard orderedViewControllers.count > previousIndex else {
            return nil
        }
        
        return orderedViewControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = orderedViewControllers.count
        
        guard orderedViewControllersCount != nextIndex else {
            return nil
        }
        
        guard orderedViewControllersCount > nextIndex else {
            return nil
        }
        
        return orderedViewControllers[nextIndex]
    }
    
    
    //MARK: - Array of ViewControllers
    
    private func newViewController(view: String) -> UIViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "\(view)ViewController")
    }
    
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        dataSource = self
        self.delegate = self
        
        let homeNav = self.newViewController(view: "Home")
        let profileNav = self.newViewController(view: "Profile")
        
        orderedViewControllers = [homeNav, profileNav]
        
        self.view.backgroundColor = UIColor.white
        self.view.applyGradient(colours: [Colors.gradientBlue, Colors.gradientPurple])
        self.view.applyGradient(colours: [Colors.purple, Colors.alertOrange], locations: [0.0, 1.0])
        
        navigationController?.navigationBar.isHidden = true
        
        setViewControllers([orderedViewControllers[0]], direction: .forward, animated: true) { (_) in
            
        }
        
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(toProfilePageTapped(_:)), name: Notifications.ProfileButtonTappedNotification, object: nil)
        
    }
    
    func toProfilePageTapped(_ notification: Notification) {
        
        // set index to 1
        
        setViewControllers([orderedViewControllers[1]], direction: .forward, animated: true) { (_) in
            
        }
        
    }
}








