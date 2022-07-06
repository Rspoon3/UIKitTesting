//
//  ViewController.swift
//  UIKitTesting
//
//  Created by Richard Witherspoon on 3/1/22.
//

import UIKit


class ViewController: UIViewController, UISplitViewControllerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureSplitVC()
    }
    
    private func configureSplitVC(){
        let split = UISplitViewController(style: .doubleColumn)
        addChild(split)
        view.addSubview(split.view)
        split.view.frame = view.bounds
        split.view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        split.didMove(toParent: self)
        split.delegate = self
        split.minimumPrimaryColumnWidth   = 400
        split.maximumPrimaryColumnWidth   = 400
        split.preferredPrimaryColumnWidth = 400
        split.presentsWithGesture = false
        split.preferredDisplayMode = .oneBesideSecondary
        split.preferredSplitBehavior = .tile
        
        let red = UIViewController()
        red.view.backgroundColor = .systemRed
        
        let detailsNav = UINavigationController(rootViewController: red)
        let main = ListVC()
        
        split.setViewController(main, for: .primary)
        split.setViewController(detailsNav, for: .secondary)
    }
    
    override func overrideTraitCollection(forChild childViewController: UIViewController) -> UITraitCollection? {
        super.overrideTraitCollection(forChild: childViewController)
        return .init(horizontalSizeClass: view.frame.width >= 800 ? .regular : .compact)
    }
}
