//
//  HapticsManager+CoreHapticsEngine.swift
//  FetchRewards
//
//  Created by Avanti Ghaisas on 3/1/22.
//  Copyright © 2022 Fetch Rewards, LLC. All rights reserved.
//

import Foundation

extension HapticsManager: HapticsEngineManaging {
    public func startEngine() {
        do {
            // Synchronously starts the haptic engine (immediately).
            try coreHapticsEngine?.start()
        } catch {
//            logger.error("Core haptic engine start error")
        }
    }

    public func stopEngine() {
        coreHapticsEngine?.stop()
    }

    public func playCustomPattern(fileName: String) {
        guard hapticFeedbackEnabled, let path = Bundle.main.path(forResource: fileName, ofType: "ahap") else { return }
        
        // Tell the engine to play a pattern.
        do {
            try coreHapticsEngine?.playPattern(from: URL(fileURLWithPath: path))
        } catch {
//            logger.error("Core haptic engine play error")
        }
    }

    public func playCustomPattern(from url: URL) {
        guard hapticFeedbackEnabled, FileManager.default.fileExists(atPath: url.path) else { return }

        do {
            try coreHapticsEngine?.playPattern(from: url)
        } catch {
//            logger.error("Core haptic play error")
        }
    }
}
