//
//  SelfSizingCollectionView.swift
//  UIKitTesting
//
//  Created by Richard Witherspoon on 6/13/22.
//

import UIKit

class SelfSizingCollectionView: UICollectionView {

    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
//        isScrollEnabled = false
//        contentInsetAdjustmentBehavior = .never
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
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
