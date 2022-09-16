//
//  ViewController.swift
//  UIKitTesting
//
//  Created by Richard Witherspoon on 3/1/22.
//

import UIKit


class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        configureStackView()
    }
    
    private func configureStackView() {
        let segmentedController = BadgedUISegmentedControl(titles: ["Open", "Closed", "Both", "Why"])
        segmentedController.setBadge(value: 12, forSegmentAt: 0, color: .systemBlue)
        segmentedController.setBadge(value: 54, forSegmentAt: 2)
        segmentedController.setBadge(value: 9, forSegmentAt: 1, color: .systemOrange)
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//            segmentedController.removeAllBadges()
//            
//            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//                segmentedController.setBadge(value: 999, forSegmentAt: 0, color: .systemBlue)
//            }
//        }
//        
        
        let red = UIView()
        red.backgroundColor = .red
        red.translatesAutoresizingMaskIntoConstraints = false
        
        let stack = UIStackView(arrangedSubviews: [red, segmentedController])
        stack.axis = .vertical
        stack.spacing = 0
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stack.leadingAnchor.constraint(lessThanOrEqualTo: view.leadingAnchor, constant: 50),
            stack.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -50),
            
            red.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}
