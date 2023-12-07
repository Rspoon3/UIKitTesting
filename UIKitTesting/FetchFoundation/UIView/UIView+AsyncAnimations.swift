//
//  UIView+AsyncAnimations.swift
//
//
//  Created by Richard Witherspoon on 11/28/23.
//

import UIKit

extension UIView {
    
    /// Animate changes to one or more views using the specified duration. A single Boolean argument is returned that indicates
    /// whether or not the animations actually finished before the completion handler was called.
    @discardableResult
    public static func animate(withDuration duration: TimeInterval, animations: @escaping () -> Void) async -> Bool {
        await withCheckedContinuation { continuation in
            animate(withDuration: duration, animations: animations) {
                continuation.resume(returning: $0)
            }
        }
    }
    
    /// Animate changes to one or more views using the specified duration, delay, spring damping, spring velocity, and view options.
    /// A single Boolean argument is returned that indicates whether or not the animations actually finished before the completion handler was called.
    @discardableResult
    public static func animate(
        withDuration duration: TimeInterval,
        delay: TimeInterval,
        usingSpringWithDamping dampingRatio: CGFloat,
        initialSpringVelocity velocity: CGFloat,
        options: UIView.AnimationOptions = [],
        animations: @escaping () -> Void
    ) async -> Bool {
        await withCheckedContinuation { continuation in
            animate(
                withDuration: duration,
                delay: delay,
                usingSpringWithDamping: dampingRatio,
                initialSpringVelocity: velocity,
                options: options,
                animations: animations
            ) {
                continuation.resume(returning: $0)
            }
        }
    }
}
