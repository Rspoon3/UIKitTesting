//
//  OrthogonalUICollectionView.swift
//  UIKitTesting
//
//  Created by Richard Witherspoon on 12/21/22.
//

import UIKit


class OrthogonalUICollectionView: UICollectionView {
    private var draggingInitiated = false
    private let contentOffsetString = "contentOffset"
    private var observer: NSKeyValueObservation?
    var didStartDragging: (() -> Void)?
    var didStopDragging: (() -> Void)?
    
    override func didAddSubview(_ subview: UIView) {
        super.didAddSubview(subview)
        
        guard
            self.observer == nil,
            let scrollView = subview as? UIScrollView
        else {
            return
        }
            
        setObserver(using: scrollView)
    }
    
    
    private func setObserver(using scrollView: UIScrollView) {
        observer = scrollView.observe(\UIScrollView.contentOffset, options: .new) { [weak self] scrollView, _ in
            guard let self else { return }
            
            if !self.draggingInitiated && scrollView.isDragging {
                self.draggingInitiated = true
                self.didStartDragging?()
            } else if self.draggingInitiated && !scrollView.isDragging {
                self.draggingInitiated = false
                self.didStopDragging?()
            }
        }
    }
    
    deinit {
        observer = nil
    }
}
