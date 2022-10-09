//
//  ViewController.swift
//  UIKitTesting
//
//  Created by Richard Witherspoon on 3/1/22.
//

import UIKit

class ViewController: UIViewController, UISplitViewControllerDelegate {
    private let details = DetailsVC()

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
        split.minimumPrimaryColumnWidth   = 400
        split.maximumPrimaryColumnWidth   = 400
        split.preferredPrimaryColumnWidth = 400
        split.presentsWithGesture = false
        split.preferredDisplayMode = .oneBesideSecondary
        split.delegate = self
        
        let detailsNav = UINavigationController(rootViewController: details)
        split.setViewController(detailsNav, for: .secondary)
        
        let list = ListVC(delegate: details)
        split.setViewController(list, for: .primary)
    }
    
    func splitViewController(_ svc: UISplitViewController, topColumnForCollapsingToProposedTopColumn proposedTopColumn: UISplitViewController.Column) -> UISplitViewController.Column {
        return details.text == nil ? .primary : .secondary
    }
}
