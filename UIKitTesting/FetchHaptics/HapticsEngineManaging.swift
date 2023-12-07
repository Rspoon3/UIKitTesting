//
//  HapticsEngineManaging.swift
//
//
//  Created by Richard Witherspoon on 11/2/23.
//

import Foundation

/// A type which plays haptics on the user's device.
public protocol HapticsEngineManaging {
    func startEngine()
    func stopEngine()
    func playCustomPattern(fileName: String)
    func playCustomPattern(from url: URL)
    func generateFeedback(_ feedbackType: FeedbackType)
    func generateFeedback(_ feedbackType: FeedbackGenerationType, named name: GeneratorName)
    func prepareFeedback(named name: GeneratorName)
    func addFeedback(_ feedbackType: FeedbackCreationType, named name: GeneratorName)
    func removeFeedback(named name: GeneratorName)
}
