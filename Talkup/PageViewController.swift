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
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "\(view)ViewController")
    }

    override func viewDidLoad() {

        
        super.viewDidLoad()
        dataSource = self
        self.delegate = self
        
        let profileNav = self.newViewController(view: "Profile")
        let homeNav = self.newViewController(view: "Home")
        
        orderedViewControllers = [profileNav, homeNav]
        
//        self.view.backgroundColor = UIColor.white
//        self.view.applyGradient(colours: [Colors.purple, Colors.gradientBlue])
//        self.view.applyGradient(colours: [Colors.purple, Colors.blueBottom], locations: [0.0, 1.0])
        
//        if orderedViewControllers.count == 2 {
//            setViewControllers([orderedViewControllers[0]], direction: .forward, animated: true, completion: nil)
//            setViewControllers([orderedViewControllers[1]], direction: .forward, animated: true, completion: nil)
//        }
        
        setViewControllers([orderedViewControllers[1]], direction: .forward, animated: true) { (_) in
            
        }

        // get scrollview
        
        for i in view.subviews {
            if i.isKind(of: UIScrollView.self) {
                (i as! UIScrollView).delegate = self
            }
        }
        
    }
    
    // scroll view 
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let colorsArray = [Colors.gradientBlue, Colors.gradientPurple, Colors.gradientPurple]
        
        let pageWidth: CGFloat = view.bounds.size.width
        let currentPage: Int = Int(floor( (scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1 )
        
        let maximumHorizontalOffset: CGFloat = scrollView.contentSize.width - scrollView.frame.size.width
        let currentHorizontalOffset: CGFloat = scrollView.contentOffset.x
        
        let percentageHorizontalOffset: CGFloat = currentHorizontalOffset / maximumHorizontalOffset
        
        print(maximumHorizontalOffset)
        print(scrollView.contentOffset)
        print(currentPage)
        
        
        if percentageHorizontalOffset < 0.5
        {
            view.backgroundColor = fadeFromColor(fromColor: colorsArray[currentPage], toColor: colorsArray[currentPage + 1], withPercentage: percentageHorizontalOffset)
        }
        else
        {
            view.backgroundColor = fadeFromColor(fromColor: colorsArray[currentPage - 1], toColor: colorsArray[currentPage], withPercentage: percentageHorizontalOffset)
        }
 
    }
    
    // color transitions 
    
    func fadeFromColor(fromColor: UIColor, toColor: UIColor, withPercentage: CGFloat) -> UIColor
    {
        var fromRed: CGFloat = 0.0
        var fromGreen: CGFloat = 0.0
        var fromBlue: CGFloat = 0.0
        var fromAlpha: CGFloat = 0.0
        
        // Get the RGBA values from the colours
        fromColor.getRed(&fromRed, green: &fromGreen, blue: &fromBlue, alpha: &fromAlpha)
        
        var toRed: CGFloat = 0.0
        var toGreen: CGFloat = 0.0
        var toBlue: CGFloat = 0.0
        var toAlpha: CGFloat = 0.0
        
        toColor.getRed(&toRed, green: &toGreen, blue: &toBlue, alpha: &toAlpha)
        
        // Calculate the actual RGBA values of the fade colour
        let red = (toRed - fromRed) * withPercentage + fromRed;
        let green = (toGreen - fromGreen) * withPercentage + fromGreen;
        let blue = (toBlue - fromBlue) * withPercentage + fromBlue;
        let alpha = (toAlpha - fromAlpha) * withPercentage + fromAlpha;
        
        // Return the fade colour
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }

}
