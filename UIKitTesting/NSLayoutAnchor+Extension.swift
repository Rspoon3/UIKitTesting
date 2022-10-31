//
//  NSLayoutAnchor+Extension.swift
//  UIKitTesting
//
//  Created by Richard Witherspoon on 10/31/22.
//

import UIKit

extension NSLayoutAnchor {
    @objc open func constraint(equalTo anchor: NSLayoutAnchor<AnchorType>, priority: UILayoutPriority) -> NSLayoutConstraint {
        let anchor = constraint(equalTo: anchor)
        anchor.priority = priority
        
        return anchor
    }
}
