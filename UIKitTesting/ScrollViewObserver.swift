//
//  ScrollViewObserver.swift
//  UIKitTesting
//
//  Created by Richard Witherspoon on 12/20/22.
//

import UIKit


final class ScrollViewObserver: NSObject, UIScrollViewDelegate {

    // MARK: - Instantiation

    init(scrollView: UIScrollView) {
        super.init()

        self.scrollView = scrollView
        self.originalScrollDelegate = scrollView.delegate
        scrollView.delegate = self
    }

    deinit {
        self.remove()
    }

    // MARK: - API

    /// Removes ourselves as an observer, resetting the scroll view's original delegate
    func remove() {
        self.scrollView?.delegate = self.originalScrollDelegate
    }

    // MARK: - Private Properties

    fileprivate weak var scrollView: UIScrollView?
    fileprivate weak var originalScrollDelegate: UIScrollViewDelegate?

    // MARK: - Forwarding Delegates

    /// Note: we forward all delegate calls here since Swift does not support forwardInvocation: or NSProxy

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.originalScrollDelegate?.scrollViewDidScroll?(scrollView)
    }

    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        self.originalScrollDelegate?.scrollViewDidZoom?(scrollView)
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        print(#function)
        self.originalScrollDelegate?.scrollViewWillBeginDragging?(scrollView)
    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        self.originalScrollDelegate?.scrollViewWillEndDragging?(scrollView, withVelocity: velocity, targetContentOffset: targetContentOffset)
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.originalScrollDelegate?.scrollViewDidEndDragging?(scrollView, willDecelerate: decelerate)
    }

    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        self.originalScrollDelegate?.scrollViewWillBeginDecelerating?(scrollView)
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.originalScrollDelegate?.scrollViewDidEndDecelerating?(scrollView)
    }

    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        self.originalScrollDelegate?.scrollViewDidEndScrollingAnimation?(scrollView)
    }

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.originalScrollDelegate?.viewForZooming?(in: scrollView)
    }

    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        self.originalScrollDelegate?.scrollViewWillBeginZooming?(scrollView, with: view)
    }

    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        self.originalScrollDelegate?.scrollViewDidEndZooming?(scrollView, with: view, atScale: scale)
    }

    func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        return self.originalScrollDelegate?.scrollViewShouldScrollToTop?(scrollView) == true
    }

    func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        self.originalScrollDelegate?.scrollViewDidScrollToTop?(scrollView)
    }
}
