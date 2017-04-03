//
//  PageViewController.swift
//  Talkup
//
//  Created by Andrew Ervin Gierke on 4/3/17.
//  Copyright © 2017 Androoo. All rights reserved.
//

import UIKit

class PageViewController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    //MARK: - Properties 
    var pageControl = UIPageControl()
    private(set) lazy var orderedViewControllers: [UIViewController] = []
    
    
    //MARK: - Page ViewController Datasource 
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
//        let pageContentViewController = pageViewController.viewControllers?[0] as? ProfileViewController
//        self.pageControl.currentPage = orderedViewControllers.index(of: pageContentViewController)
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
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "\(view)NavigationController")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        self.delegate = self
        
        let profileNav = self.newViewController(view: "Profile")
        let homeNav = self.newViewController(view: "Home")
        
        orderedViewControllers = [profileNav, homeNav]
        
//        if orderedViewControllers.count == 2 {
//            setViewControllers([orderedViewControllers[0]], direction: .forward, animated: true, completion: nil)
//            setViewControllers([orderedViewControllers[1]], direction: .forward, animated: true, completion: nil)
//        }
        
        setViewControllers([orderedViewControllers[1]], direction: .forward, animated: true) { (_) in
            
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

}
