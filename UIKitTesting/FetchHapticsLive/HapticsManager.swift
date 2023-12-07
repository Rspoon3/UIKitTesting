//
//  HapticsManager.swift
//  FetchHop
//
//  Created by Gray Campbell on 9/20/21.
//  Copyright © 2021 Fetch Rewards, LLC. All rights reserved.
//

import UIKit
import CoreHaptics
import AVKit
import OSLog

/// An object which plays device haptics.
public final class HapticsManager {
    
    // MARK: Properties
    
    /// The shared haptic feedback manager.
    public static let shared = HapticsManager()
    
    ///  Use Core Haptics engine to create hugely customizable haptics by combining taps, continuous vibrations, parameter curves, and more.
    ///  Although it’s possible to create content—CHHapticPattern instances—independent of a CHHapticEngine, your app must use an engine to play that content.
    ///  https://developer.apple.com/documentation/corehaptics/chhapticengine
    var coreHapticsEngine: CHHapticEngine?
    
    /// The feedback generators managed by the haptics manager.
    private(set) var feedbackGenerators: [GeneratorName: UIFeedbackGenerator] = [:]
    
//    let logger = Logger(category: HapticsManager.self)
    private let userDefaults: UserDefaults
    
    var hapticFeedbackEnabled: Bool {
        userDefaults.value(forKey: "hapticFeedbackEnabled") as? Bool ?? true
    }
    
    // MARK: Initializers
    
    public init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
        
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        
        // Create and configure a haptic engine.
        do {
            // Associate the haptic engine with the default audio session
            // to ensure the correct behavior when playing audio-based haptics.
            // CHHapticEngine needs the audioSession for celebration haptics to play properly,
            // it appears ahap file haptics can be "audio-based" even if they aren't playing any actual audio.
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.ambient)
            coreHapticsEngine = try CHHapticEngine(audioSession: audioSession)
        } catch {
//            logger.error("Haptic engine config error")
        }
        
        // Start engine
        do {
            try coreHapticsEngine?.start()
        } catch {
//            logger.error("Haptic engine start error")
        }
    }
    
    // MARK: Static Generator
    
    /// Generates one-off, unprepared feedback.
    ///
    /// - Parameters:
    ///   - feedbackType: The type of feedback to generate.
    @MainActor
    public func generateFeedback(_ feedbackType: FeedbackType) {
        guard self.hapticFeedbackEnabled else { return }
        
        switch feedbackType {
        case .impact(let style, .none):
            UIImpactFeedbackGenerator(style: style).impactOccurred()
        case .impact(let style, .some(let intensity)):
            UIImpactFeedbackGenerator(style: style).impactOccurred(intensity: intensity.clamped(to: 0...1))
        case .selection:
            UISelectionFeedbackGenerator().selectionChanged()
        case .notification(let type):
            UINotificationFeedbackGenerator().notificationOccurred(type)
        }
    }
    
    // MARK: Managed Generator
    
    /// Adds a feedback generator identified by the provided name to the haptics manager.
    ///
    /// - Parameters:
    ///   - feedbackType: The type of feedback generator to add.
    ///   - name: The name for the feedback generator.
    @MainActor
    public func addFeedback(_ feedbackType: FeedbackCreationType, named name: GeneratorName) {
        switch feedbackType {
        case .impact(let style):
            feedbackGenerators[name] = UIImpactFeedbackGenerator(style: style)
        case .selection:
            feedbackGenerators[name] = UISelectionFeedbackGenerator()
        case .notification:
            feedbackGenerators[name] = UINotificationFeedbackGenerator()
        }
    }
    
    /// Prepares the feedback generator identified by the provided name.
    ///
    /// - Parameters:
    ///   - name: The name of the feedback generator.
    @MainActor
    public func prepareFeedback(named name: GeneratorName) {
        feedbackGenerators[name]?.prepare()
    }
    
    /// Generates feedback using a generator identified by the provided name.
    ///
    /// - Parameters:
    ///   - feedbackType: The type of feedback to generate.
    ///   - name: The name of the feedback generator.
    @MainActor
    public func generateFeedback(_ feedbackType: FeedbackGenerationType, named name: GeneratorName) {
        guard hapticFeedbackEnabled else { return }
        
        switch feedbackType {
        case .impact(.none):
            let feedbackGenerator = feedbackGenerator(UIImpactFeedbackGenerator.self, named: name)
            feedbackGenerator?.impactOccurred()
        case .impact(.some(let intensity)):
            let feedbackGenerator = feedbackGenerator(UIImpactFeedbackGenerator.self, named: name)
            feedbackGenerator?.impactOccurred(intensity: intensity.clamped(to: 0...1))
        case .selection:
            let feedbackGenerator = feedbackGenerator(UISelectionFeedbackGenerator.self, named: name)
            
            feedbackGenerator?.selectionChanged()
        case .notification(let type):
            let feedbackGenerator = feedbackGenerator(UINotificationFeedbackGenerator.self, named: name)
            
            feedbackGenerator?.notificationOccurred(type)
        }
    }
    
    /// Removes the feedback generator identified by the provided name from the haptics manager.
    ///
    /// - Parameters:
    ///   - name: The name of the feedback generator.
    @MainActor
    public func removeFeedback(named name: GeneratorName) {
        feedbackGenerators.removeValue(forKey: name)
    }
    
    // MARK: Private Getter
    
    private func feedbackGenerator<G>(_ type: G.Type, named name: GeneratorName) -> G? {
        feedbackGenerators[name] as? G
    }
}
