//
//  PageVC.swift
//  PageViewControllerTutorial
//
//  Created by Volodymyr Romanov on 10/10/16.
//  Copyright © 2016 Vladimir Romanov. All rights reserved.
//

import UIKit

class PageVC: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    

    lazy var VCArr: [UIViewController] = {
        return [
                UIStoryboard(name: "Tutorial", bundle: nil).instantiateViewController(withIdentifier: "FirstVC"),
                UIStoryboard(name: "Tutorial", bundle: nil).instantiateViewController(withIdentifier: "SecondVC"),
                UIStoryboard(name: "Tutorial", bundle: nil).instantiateViewController(withIdentifier: "ThirdVC"),
                UIStoryboard(name: "Tutorial", bundle: nil).instantiateViewController(withIdentifier: "FourthVC"),
                UIStoryboard(name: "Tutorial", bundle: nil).instantiateViewController(withIdentifier: "FifthVC"),
                UIStoryboard(name: "Tutorial", bundle: nil).instantiateViewController(withIdentifier: "FinalVC")]
    }()
    
    private func VCInstance(name: String) -> UIViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: name)
    }
    
    override func viewDidLoad() {
     //   let storyboard = UIStoryboard(name: "Tutorial", bundle: nil)

        
        super.viewDidLoad()
        self.dataSource = self
        self.delegate = self
        if let firstVC = VCArr.first {
            setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }
    }
    
    
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        for view in self.view.subviews {
            if view is UIScrollView {
                view.frame = UIScreen.main.bounds
            } else if view is UIPageControl {
                view.backgroundColor = UIColor.clear
            }
        }
    }
    

    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = VCArr.index(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return nil//VCArr.first
        }
        
        guard VCArr.count > previousIndex else {
            return nil
        }
        
        return VCArr[previousIndex]
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = VCArr.index(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        
        guard nextIndex < VCArr.count else {
            
            return nil//VCArr.first
        }
        
        guard VCArr.count > nextIndex else {
            return nil
        }
        
        return VCArr[nextIndex]
    }
    
    public func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return VCArr.count
    }
    

    public func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        guard let firstViewController = viewControllers?.first,
            let firstViewControllerIndex = VCArr.index(of: firstViewController) else {
                return 0
        }
        
        return firstViewControllerIndex
    }
}
