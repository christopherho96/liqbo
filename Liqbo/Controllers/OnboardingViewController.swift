//
//  OnboardingViewController.swift
//  Liqbo
//
//  Created by Christopher Ho on 2017-12-21.
//  Copyright © 2017 chovo. All rights reserved.
//

import UIKit

class OnboardingViewController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {

    lazy var orderedViewControllers: [UIViewController] = {
        return [self.newVc(viewController: "onboard1"),
                self.newVc(viewController: "onboard2"),
                self.newVc(viewController: "onboard3")]
    }()
    
    var pageControl = UIPageControl()
    var skipButton = UIButton()
    var nextButton = UIButton()
    var currentIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataSource = self
        
        // This sets up the first view that will show up on our page control
        if let firstViewController = orderedViewControllers.first {
            setViewControllers([firstViewController],
                               direction: .forward,
                               animated: true,
                               completion: nil)
        }
        
        self.delegate = self
        configurePageControl()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {

    }
    
    func configurePageControl() {
        // The total number of pages that are available is based on how many available colors we have.
        pageControl = UIPageControl(frame: CGRect(x: 0,y: UIScreen.main.bounds.maxY - 50,width: UIScreen.main.bounds.width,height: 50))
        
        skipButton = UIButton(frame: CGRect(x: (UIScreen.main.bounds.maxX) * 0.05,y: UIScreen.main.bounds.maxY - 50,width: 50,height: 50))
        //skipButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        skipButton.backgroundColor = UIColor.clear
        skipButton.setTitle("Skip", for: .normal)
        skipButton.addTarget(self, action: #selector(buttonAction), for: UIControlEvents.touchUpInside)
        skipButton.tag = 1
        
        nextButton = UIButton(frame: CGRect(x: (UIScreen.main.bounds.maxX) * 0.80,y: UIScreen.main.bounds.maxY - 50,width: 50,height: 50))
        
        nextButton.backgroundColor = UIColor.clear
        nextButton.setTitle("Next", for: .normal)
        nextButton.addTarget(self, action: #selector(buttonAction), for: UIControlEvents.touchUpInside)
        nextButton.tag = 2
        
       
        
        self.pageControl.numberOfPages = orderedViewControllers.count
        self.pageControl.currentPage = 0
      //  self.pageControl.tintColor = UIColor.black
        //self.pageControl.pageIndicatorTintColor = UIColor.clear
       // self.pageControl.currentPageIndicatorTintColor = UIColor.white
        
        let image = UIImage.outlinedEllipse(size: CGSize(width: 7.0, height: 7.0), color: .white)
        self.pageControl.pageIndicatorTintColor = UIColor.init(patternImage: image!)
        self.pageControl.currentPageIndicatorTintColor = .white
        
        
        self.view.addSubview(pageControl)
        self.view.addSubview(skipButton)
        self.view.addSubview(nextButton)
        
    }
    
    @objc func buttonAction ( sender: UIButton!){
        
        if sender.tag == 1{
            print("skip pressed")
        }
        else{
            //print("next pressed")
            
            if currentIndex == 3{
                print ("test worked")
                performSegue(withIdentifier: "leaveOnboardingSegue", sender: nil)
                let defaults = UserDefaults.standard
                defaults.set(true, forKey:"firstTime")
                //remember to change the firstTime key value when publishing
            }
         
        }
    }
    
    func newVc(viewController: String) -> UIViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: viewController)
    }
    
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let pageContentViewController = pageViewController.viewControllers![0]
        self.pageControl.currentPage = orderedViewControllers.index(of: pageContentViewController)!
    }
    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        // User is on the first view controller and swiped left to loop to
        // the last view controller.
        guard previousIndex >= 0 else {
            //return orderedViewControllers.last
            // Uncommment the line below, remove the line above if you don't want the page control to loop.
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
        currentIndex = nextIndex
        let orderedViewControllersCount = orderedViewControllers.count
        
        // User is on the last view controller and swiped right to loop to
        // the first view controller.
        guard orderedViewControllersCount != nextIndex else {
            //return orderedViewControllers.first
            // Uncommment the line below, remove the line above if you don't want the page control to loop.
            return nil
        }
        
        guard orderedViewControllersCount > nextIndex else {
            return nil
        }
        
        return orderedViewControllers[nextIndex]
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension UIImage {
    class func outlinedEllipse(size: CGSize, color: UIColor, lineWidth: CGFloat = 1.0) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        
        context.setStrokeColor(color.cgColor)
        context.setLineWidth(lineWidth)
        let rect = CGRect(origin: .zero, size: size).insetBy(dx: lineWidth * 0.5, dy: lineWidth * 0.5)
        context.addEllipse(in: rect)
        context.strokePath()
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
