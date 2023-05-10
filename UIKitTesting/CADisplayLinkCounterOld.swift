//
//  CADisplayLinkCounterOld.swift
//  UIKitTesting
//
//  Created by Richard Witherspoon on 5/9/23.
//

import UIKit

/// A counter that uses 'CADisplayLink' to count along with the screens frame rate
///
/// Primarily used to update a text label with a number that increases over time
@MainActor final class CADisplayLinkCounterOld {
    private var continuation: AsyncStream<Double>.Continuation?
    private var displayLink: CADisplayLink?
    private var parameters: Parameters?
    
    private struct Parameters {
        let startDate = Date()
        let startValue: Double
        let endValue: Double
        let duration: Double
    }
    
    // MARK: - Public
    
    /// Starts the count
    func count(
        from startValue : Double,
        to endValue : Double,
        duration: Double
    ) -> AsyncStream<Double> {
        AsyncStream { continuation in
            self.continuation = continuation
            
            parameters = Parameters(
                startValue: startValue,
                endValue: endValue,
                duration: duration
            )
            
            displayLink = CADisplayLink(target: self, selector: #selector(handleUpdate))

            // Need to add to both default and tracking otherwise the count will
            // pause if the user scrolls during the animation
            displayLink?.add(to: .main, forMode: .default)
            displayLink?.add(to: .main, forMode: .tracking)
        }
    }
    
    // MARK: - Private
    
    @objc private func handleUpdate() {
        guard let parameters, let continuation else {
            cancel()
            return
        }
        
        let elapsedTime = Date.now.timeIntervalSince(parameters.startDate)
        
        if elapsedTime > parameters.duration {
            continuation.yield(parameters.endValue)
            cancel()
        } else {
            let percentage = elapsedTime / parameters.duration
            let difference = parameters.endValue - parameters.startValue
            let newValue = parameters.startValue + percentage * difference
        
            continuation.yield(newValue)
        }
    }
    
    private func cancel() {
        displayLink?.invalidate()
        displayLink = nil
        
        continuation?.finish()
        continuation = nil
    }
}
