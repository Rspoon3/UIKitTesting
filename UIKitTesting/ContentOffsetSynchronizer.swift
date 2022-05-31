//
//  ContentOffsetSynchronizer.swift
//  UIKitTesting
//
//  Created by Richard Witherspoon on 5/31/22.
//

import UIKit


final class ContentOffsetSynchronizer : ObservableObject {
    private var observations: [NSKeyValueObservation] = []
    let registrations = NSHashTable<UIScrollView>.weakObjects()

    private var contentOffset: CGPoint = .zero {
        didSet {
            // Sync all scrollviews with to the new content offset
            for scrollView in registrations.allObjects where (scrollView.isDragging || scrollView.isDecelerating) == false {
                scrollView.contentOffset.x = contentOffset.x
            }
        }
    }

    func register(_ scrollView: UIScrollView) {
        scrollView.clipsToBounds = false

        guard registrations.contains(scrollView) == false else {
            return
        }

        registrations.add(scrollView)

        // When a user is interacting with the scrollView, we store its contentOffset
        observations.append(
            scrollView.observe(\.contentOffset, options: [.initial, .new]) { [weak self] scrollView, change in
                guard let newValue = change.newValue, (scrollView.isDragging || scrollView.isDecelerating) else {
                    return
                }
                self?.contentOffset = newValue
            }
        )
        
        // If a contentSize changes, we need to re-sync it with the current contentOffset
        observations.append(
            scrollView.observe(\.contentSize, options: [.initial, .new]) { [weak self] scrollView, change in
                guard let contentOffset = self?.contentOffset else {
                    return
                }
                scrollView.contentOffset.x = contentOffset.x
            }
        )
    }
    
    deinit {
        observations.forEach { $0.invalidate() }
    }
}
