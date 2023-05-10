//
//  CADisplayLinkCounter.swift
//  UIKitTesting
//
//  Created by Richard Witherspoon on 5/9/23.
//

import UIKit

/// A counter that uses 'CADisplayLink' to count along with the screens frame rate
///
/// Primarily used to update a text label with a number that increases over time
@MainActor final class CADisplayLinkCounter {
    private let startDate: Date = .now
    private let startValue: Double
    private let endValue: Double
    private let duration: Double
    private var updateHandler: @MainActor (Double) -> Void = { _ in }
    private var completionHandler: @MainActor () -> Void = { }
    private var displayLink: CADisplayLink?
    
    // MARK: - Initializer
    
    private init(
        startValue: Double,
        endValue: Double,
        duration: Double
    ) {
        self.startValue = startValue
        self.endValue = endValue
        self.duration = duration
    }
    
    
    // MARK: - Public
    
    
    @MainActor static func count(
        from startValue : Double,
        to endValue : Double,
        duration: Double
    ) -> AsyncStream<Double> {
        AsyncStream { continuation in
            let counter = CADisplayLinkCounter(
                startValue: startValue,
                endValue: endValue,
                duration: duration
            )
            counter.updateHandler = { value in
                continuation.yield(value)
            }
            counter.completionHandler = {
                continuation.finish()
            }
            continuation.onTermination = { @Sendable _ in
                Task {
                    await counter.invalidateDisplayLink()
                }
            }
            counter.start()
        }
    }


    // MARK: - Private
    
    private func start() {
        displayLink = CADisplayLink(target: self, selector: #selector(update))
        displayLink?.add(to: .main, forMode: .default)
        displayLink?.add(to: .main, forMode: .tracking)
    }

    private func invalidateDisplayLink() {
        displayLink?.invalidate()
        displayLink = nil
    }

    @objc private func update() {
        let percentage = -startDate.timeIntervalSinceNow / 10.0
        let difference = 10.0
        let newValue = percentage * difference
        updateHandler(newValue)
        
        let elapsedTime = Date.now.timeIntervalSince(startDate)
        
        if elapsedTime > duration {
            invalidateDisplayLink()
            updateHandler(endValue)
            completionHandler()
        } else {
            let percentage = elapsedTime / duration
            let difference = endValue - startValue
            let newValue = startValue + percentage * difference
        
            updateHandler(newValue)
        }
    }
}
