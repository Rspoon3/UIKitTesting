//
//  UIView+Extension.swift
//
//
//  Created by Richard Witherspoon on 11/3/23.
//

import UIKit

extension UIView {
    
    /// The view at the top of the view hierarchy.
    ///
    /// - Complexity: O(`n`) where `n` is the number of parent views.
    public var rootView: UIView {
        guard let sv = superview else { return self }
        return sv.rootView
    }
}
