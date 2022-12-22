//
//  OrthogonalUICollectionView.swift
//  UIKitTesting
//
//  Created by Richard Witherspoon on 12/21/22.
//

import UIKit


class OrthogonalUICollectionView: UICollectionView {
    var needScrollView = true
    var draggingInitiated = false
    private let contentOffsetString = "contentOffset"
    private var observer: NSKeyValueObservation?
   
    
    override func layoutSubviews() {
        super.layoutSubviews()
        guard needScrollView else { return }
        
        for subview in subviews {
            guard let scrollView = subview as? UIScrollView else { continue }
            setObserver(using: scrollView)
            needScrollView = false
            break
        }
    }
    
    private func setObserver(using scrollView: UIScrollView) {
        observer = scrollView.observe(\UIScrollView.contentOffset, options: .new) { [weak self] scrollView, _ in
            guard let self else { return }
            
            if !self.draggingInitiated && scrollView.isDragging {
                self.draggingInitiated = true
                print("Started Dragging")
            } else if self.draggingInitiated && !scrollView.isDragging {
                self.draggingInitiated = false
                print("Ended Dragging")
            }
        }
    }
    
    deinit {
        observer = nil
    }
}
