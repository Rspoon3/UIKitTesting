//
//  CADisplayLinkCounter.swift
//  UIKitTesting
//
//  Created by Richard Witherspoon on 5/9/23.
//

import UIKit

/// A counter that uses 'CADisplayLink' to count up with the screens frame rate
///
/// ```swift
/// @MainActor func foo() async {
///     let label = UILabel()
///     let counterSequence = CADisplayLinkCounter.count(from: 0, to: 100, duration: 0.5)
///
///     for await value in counterSequence {
///         label.text = value.formatted()
///     }
/// }
/// ```
/// Primarily used to update a text label with a number that increases over time.
///
/// Private init to avoid others from misusing and causing a memory leak- should only ever access the static count method
///
/// - Parameters:
///     - duration: The duration of the animation in seconds
@MainActor final class CADisplayLinkCounter {
    private let startDate: Date = .now
    private let startValue: Double
    private let endValue: Double
    private let method: CountingMethod
    private let duration: TimeInterval
    private var updateHandler: @MainActor (Double) -> Void = { _ in }
    private var completionHandler: @MainActor () -> Void = { }
    private var displayLink: CADisplayLink?
    
    // MARK: - Initializer
    
    private init(
        startValue: Double,
        endValue: Double,
        duration: Double,
        method: CountingMethod
    ) {
        self.startValue = startValue
        self.endValue = endValue
        self.duration = duration
        self.method = method
    }
    
    // MARK: - Public
    
    @MainActor static func count(
        from startValue: Double,
        to endValue: Double,
        duration: TimeInterval,
        method: CountingMethod
    ) -> AsyncStream<Double> {
        AsyncStream { continuation in
            let counter = CADisplayLinkCounter(
                startValue: startValue,
                endValue: endValue,
                duration: duration,
                method: method
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
        updateHandler(startValue)
        
        displayLink = CADisplayLink(target: self, selector: #selector(update))
        displayLink?.add(to: .main, forMode: .default)
        displayLink?.add(to: .main, forMode: .tracking)
    }
    
    private func invalidateDisplayLink() {
        displayLink?.invalidate()
        displayLink = nil
    }
    
    @objc private func update() {
        let elapsedTime = Date.now.timeIntervalSince(startDate)
        
        if elapsedTime > duration {
            invalidateDisplayLink()
            updateHandler(endValue)
            completionHandler()
        } else {
            let percentage = elapsedTime / duration
            let updateValue = method.value(from: percentage)
            let difference = endValue - startValue
            let newValue = startValue + updateValue * difference
            
            updateHandler(newValue)
        }
    }
}
