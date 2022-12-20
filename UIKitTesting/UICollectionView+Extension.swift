//
//  UICollectionView+Extension.swift
//  UIKitTesting
//
//  Created by Richard Witherspoon on 12/20/22.
//

import UIKit

extension UICollectionView {
    func horizontalUIScrollViews() -> [UIScrollView] {
        subviews.compactMap{ view in
            guard String(describing: type(of: view)) == "_UICollectionViewOrthogonalScrollerEmbeddedScrollView" else { return nil }
            return view as? UIScrollView
        }
    }
}
