//
//  ViewController.swift
//  UIKitTesting
//
//  Created by Richard Witherspoon on 12/31/22.
//

import UIKit


final class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationControllers()
    }
    
    private func setupNavigationControllers() {
        let orthogonalVC = OrthogonalViewController()
        orthogonalVC.navigationItem.title = "Orthogonal Carousel Layout"
        orthogonalVC.tabBarItem = UITabBarItem(title: "Orthogonal",
                                               image: UIImage(systemName: "1.circle"),
                                               tag: 0)
        
        let customCarouselLayoutVC = CustomCarouselLayoutVC()
        customCarouselLayoutVC.navigationItem.title = "Custom Carousel Layout"
        customCarouselLayoutVC.tabBarItem = UITabBarItem(title: "Custom Carousel",
                                                         image: UIImage(systemName: "2.circle"),
                                                         tag: 1)
        
//        viewControllers = [UINavigationController(rootViewController: orthogonalVC),
//                           UINavigationController(rootViewController: customCarouselLayoutVC)]
        
        viewControllers = [UINavigationController(rootViewController: customCarouselLayoutVC),
                           UINavigationController(rootViewController: orthogonalVC)]
    }
}
