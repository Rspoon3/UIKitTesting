//
//  BadgedUISegmentedControl.swift
//  UIKitTesting
//
//  Created by Richard Witherspoon on 9/16/22.
//

import UIKit


class BadgedUISegmentedControl: UIView{
    let segmentControl: UISegmentedControl
    var modifiedTopAnchor: NSLayoutConstraint!
    private var badgeInfos = Set<BadgeInfo>()
    
    private struct BadgeInfo: Identifiable, Hashable {
        let id = UUID()
        let segment: Int
        let badge: UIView
        let segmentView: UIView
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        for info in badgeInfos {
            let x = info.segmentView.frame.maxX - (info.badge.frame.width / 1.5)
            info.badge.frame.origin = .init(x: x, y: info.segmentView.frame.minY)
        }
    }
    
    init(titles: [String]){
        segmentControl = UISegmentedControl(items: titles)
        super.init(frame: .zero)
        
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureViews() {
        segmentControl.translatesAutoresizingMaskIntoConstraints = false
        addSubview(segmentControl)
        
        translatesAutoresizingMaskIntoConstraints = false
        
        modifiedTopAnchor = topAnchor.constraint(equalTo: segmentControl.topAnchor)
        NSLayoutConstraint.deactivate(constraints)
        
        let segmentTop = segmentControl.topAnchor.constraint(equalTo: topAnchor)
        segmentTop.priority = .defaultLow
        
        NSLayoutConstraint.activate([
            segmentTop,
            segmentControl.bottomAnchor.constraint(equalTo: bottomAnchor),
            segmentControl.leadingAnchor.constraint(equalTo: leadingAnchor),
            segmentControl.trailingAnchor.constraint(equalTo:  trailingAnchor),
            
            modifiedTopAnchor,
            bottomAnchor.constraint(equalTo: segmentControl.bottomAnchor),
            leadingAnchor.constraint(equalTo: segmentControl.leadingAnchor),
            trailingAnchor.constraint(equalTo: segmentControl.trailingAnchor),
        ])
    }
    
    func removeAllBadges(){
        badgeInfos.forEach{$0.badge.removeFromSuperview()}
        badgeInfos.removeAll()
    }
    
    func removeBadge(forSegmentAt segment: Int){
        for info in badgeInfos.filter({$0.segment == segment}) {
            info.badge.removeFromSuperview()
            badgeInfos.remove(info)
        }
    }
    
    func badge(forSegmentAt segment: Int) -> UIView?{
        return badgeInfos.first(where: {$0.segment == segment})?.badge
    }
    
    func setBadge(value: Int, forSegmentAt segment: Int, color: UIColor = .systemRed){
        let isSingleDigit = value < 10
        let padding: CGFloat = isSingleDigit ? 2 : 5
        let max: CGFloat = 16

        guard
            segment < segmentControl.subviews.count,
            let title = segmentControl.titleForSegment(at: segment),
            let segmentView = segmentControl.subviews.first(where: {$0.subviews.compactMap{$0 as? UILabel}.compactMap(\.text).contains(title)})
        else {
            print("Can't create segmented control badge.")
            return
        }
        
        removeBadge(forSegmentAt: segment)
        
        let badeLabel = UILabel()
        badeLabel.text = "\(value)"
        badeLabel.textColor = .white
        badeLabel.textAlignment = .center
        badeLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        badeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let badge = UIView()
        badge.translatesAutoresizingMaskIntoConstraints = false
        badge.backgroundColor = color
        badge.layer.masksToBounds = true
        badge.layer.cornerRadius = max / 2
        badge.addSubview(badeLabel)

        let info = BadgeInfo(segment: segment, badge: badge, segmentView: segmentView)
        badgeInfos.insert(info)
        addSubview(badge)
        
        modifiedTopAnchor.isActive = false
        modifiedTopAnchor = topAnchor.constraint(equalTo: badge.topAnchor)
        
        badge.widthAnchor.constraint(equalToConstant: max).isActive = isSingleDigit
        NSLayoutConstraint.activate([
            modifiedTopAnchor,
            badge.heightAnchor.constraint(equalToConstant: max),
            badge.topAnchor.constraint(equalTo: segmentView.topAnchor, constant: -max / 2.5),
            
            badeLabel.topAnchor.constraint(equalTo: badge.topAnchor, constant: -padding),
            badeLabel.bottomAnchor.constraint(equalTo: badge.bottomAnchor, constant: padding),
            badeLabel.leadingAnchor.constraint(equalTo: badge.leadingAnchor, constant: padding),
            badeLabel.trailingAnchor.constraint(equalTo: badge.trailingAnchor, constant: -padding),
        ])
    }
}
