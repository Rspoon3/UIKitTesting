//
//  OrthogonalUICollectionView.swift
//  UIKitTesting
//
//  Created by Richard Witherspoon on 12/21/22.
//

import UIKit

class OrthogonalUICollectionView: UICollectionView, UIScrollViewDelegate {
    var didStartDragging: (() -> Void)?
    private weak var scrollView: UIScrollView?
    private weak var originalScrollDelegate: UIScrollViewDelegate?
    private var startOfScrollContentOffset = CGPoint(x: 0, y: 0)
    private var lastTargetContentOffsetX: CGFloat?

    deinit {
        scrollView?.delegate = originalScrollDelegate
        print(#function)
    }
    
    override func didAddSubview(_ subview: UIView) {
        super.didAddSubview(subview)
        
        attemptToConfigureScrollView(using: subview)
    }
    
    private func attemptToConfigureScrollView(using subview: UIView) {
        guard let view = subview as? UIScrollView else {
            return
        }
        
        scrollView = view
        originalScrollDelegate = view.delegate
        scrollView?.delegate = self
    }
    
    internal func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        didStartDragging?()
        startOfScrollContentOffset = scrollView.contentOffset
        originalScrollDelegate?.scrollViewWillBeginDragging?(scrollView)
    }
    
    internal func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let scrollDistance = scrollView.contentOffset.x - startOfScrollContentOffset.x
        let threshold = frame.width / 2
        
        if let lastTargetContentOffsetX {
            let value = targetContentOffset.pointee.x - lastTargetContentOffsetX
            
            if abs(value) > threshold {
                if value > 0 {
                    targetContentOffset.pointee.x = startOfScrollContentOffset.x + threshold
                } else {
                    targetContentOffset.pointee.x = startOfScrollContentOffset.x - threshold
                }
            }
        } else if abs(scrollDistance) > threshold {
            if scrollDistance > 0 {
                targetContentOffset.pointee.x = startOfScrollContentOffset.x + threshold
            } else {
                targetContentOffset.pointee.x = startOfScrollContentOffset.x - threshold
            }
        }
        
        lastTargetContentOffsetX = targetContentOffset.pointee.x
        
        originalScrollDelegate?.scrollViewWillEndDragging?(scrollView, withVelocity: velocity, targetContentOffset: targetContentOffset)
    }
    
    internal func scrollViewDidScroll(_ scrollView: UIScrollView) {
        originalScrollDelegate?.scrollViewDidScroll?(scrollView)
    }
    
    internal func scrollViewDidZoom(_ scrollView: UIScrollView) {
        originalScrollDelegate?.scrollViewDidZoom?(scrollView)
    }
    
    internal func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        originalScrollDelegate?.scrollViewDidEndDragging?(scrollView, willDecelerate: decelerate)
    }
    
    internal func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        originalScrollDelegate?.scrollViewWillBeginDecelerating?(scrollView)
    }
    
    internal func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        originalScrollDelegate?.scrollViewDidEndDecelerating?(scrollView)
    }
    
    internal func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        originalScrollDelegate?.scrollViewDidEndScrollingAnimation?(scrollView)
    }
    
    internal func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return originalScrollDelegate?.viewForZooming?(in: scrollView)
    }
    
    internal func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        originalScrollDelegate?.scrollViewWillBeginZooming?(scrollView, with: view)
    }
    
    internal func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        originalScrollDelegate?.scrollViewDidEndZooming?(scrollView, with: view, atScale: scale)
    }
    
    internal func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        return originalScrollDelegate?.scrollViewShouldScrollToTop?(scrollView) == true
    }
    
    internal func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        originalScrollDelegate?.scrollViewDidScrollToTop?(scrollView)
    }
}
