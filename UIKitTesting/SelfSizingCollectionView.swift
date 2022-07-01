//
//  SelfSizingCollectionView.swift
//  UIKitTesting
//
//  Created by Richard Witherspoon on 6/13/22.
//

import UIKit

class SelfSizingCollectionView: UICollectionView {
    override var contentSize: CGSize {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        invalidateIntrinsicContentSize()
    }

    override var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        
        let size = CGSize(
            width: UIView.noIntrinsicMetric,
            height: collectionViewLayout.collectionViewContentSize.height
        )
        return size
    }
}
