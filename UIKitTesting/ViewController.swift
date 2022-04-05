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
        let control = createSegmentedController()
        control.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(control)
        
        control.setBadge(value: 54, forSegmentAt: 2)
        control.setBadge(value: 9, forSegmentAt: 1, color: .systemOrange)
                
     
        NSLayoutConstraint.activate([
            control.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            control.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            control.widthAnchor.constraint(equalToConstant: 400),
        ])
    }
    
    private func createSegmentedController()->BadgedUISegmentedControl{
        let segmentedController = BadgedUISegmentedControl(items: ["Open", "Closed", "Both", "Why"])
        segmentedController.selectedSegmentIndex = 0
        segmentedController.selectedSegmentTintColor = .systemBlue
        segmentedController.setTitleTextAttributes([.foregroundColor:UIColor.white], for: .selected)
        return segmentedController
    }
}

class BadgedUISegmentedControl: UISegmentedControl{
    var badges = Set<UIView>()
    
    private func createTag(from value: Int) -> Int{
        let multiplier = 12345
        return value * multiplier
    }
    
    func removeAllBadges(){
        badges.forEach{$0.removeFromSuperview()}
        badges.removeAll()
    }
    
    func removeBadge(forSegmentAt segment: Int){
        let exitingTags = badges.filter{$0.tag == createTag(from: segment)}
        
        for tag in exitingTags{
            badges.remove(tag)
            tag.removeFromSuperview()
        }
    }
    
    func badge(forSegmentAt segment: Int) -> UIView?{
        guard segment < subviews.count else {
            return nil
        }
        
        let exitingTags = badges.filter{$0.tag == createTag(from: segment)}
        return exitingTags.first
    }

    func setBadge(value: Int, forSegmentAt segment: Int, color: UIColor = .systemRed){
        let max: CGFloat = 16
        let isSingleDigit = value < 10
        let padding: CGFloat = isSingleDigit ? 2 : 5
        
        guard
            segment < subviews.count,
            let superview = superview,
            let title = titleForSegment(at: segment),
            let segmentView = subviews.first(where: {$0.subviews.compactMap{$0 as? UILabel}.compactMap(\.text).contains(title)})
        else {
            print("Can't create segmented control badge.")
            return
        }
        
        removeBadge(forSegmentAt: segment)
        
        let badgeView = UILabel()
        badgeView.text = "\(value)"
        badgeView.textColor = .white
        badgeView.textAlignment = .center
        badgeView.font = .systemFont(ofSize: 14, weight: .semibold)
        badgeView.translatesAutoresizingMaskIntoConstraints = false
        
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.backgroundColor = color
        container.layer.masksToBounds = true
        container.addSubview(badgeView)
        container.tag = createTag(from: segment)
        
        badges.insert(container)
        superview.addSubview(container)
        
        container.widthAnchor.constraint(equalToConstant: max).isActive = isSingleDigit
        container.layer.cornerRadius = max / 2

        NSLayoutConstraint.activate([
            container.heightAnchor.constraint(equalToConstant: max),
            container.topAnchor.constraint(equalTo: segmentView.topAnchor, constant: -max / 2.5),
            container.trailingAnchor.constraint(equalTo: segmentView.trailingAnchor, constant: max / 2.5),
            
            badgeView.topAnchor.constraint(equalTo: container.topAnchor, constant: -padding),
            badgeView.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: padding),
            badgeView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: padding),
            badgeView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -padding),
        ])
    }
}
