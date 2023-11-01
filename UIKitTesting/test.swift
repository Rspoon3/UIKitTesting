//
//  test.swift
//  UIKitTesting
//
//  Created by Richard Witherspoon on 10/25/23.
//

import UIKit



final class HapticsManager {
}

extension HapticsManager {

    /// Feedback type for one-off haptics that don't call `prepare()`.
    enum FeedbackType: Equatable {

        /// Impact feedback with style and optional intensity.
        case impact(_ style: UIImpactFeedbackGenerator.FeedbackStyle, intensity: CGFloat? = nil)

        /// Selection feedback.
        case selection

        /// Notification feedback of type.
        case notification(_ type: UINotificationFeedbackGenerator.FeedbackType)
    }

    /// Feedback type for creating a new feedback generator managed by the haptics manager.
    enum FeedbackCreationType: Equatable {

        /// Impact feedback with style.
        case impact(_ style: UIImpactFeedbackGenerator.FeedbackStyle)

        /// Selection feedback.
        case selection

        /// Notification feedback.
        case notification
    }

    /// Feedback type for generating feedback from a generator managed by the haptics manager.
    enum FeedbackGenerationType: Equatable {

        /// Impact feedback with optional intensity.
        case impact(intensity: CGFloat? = nil)

        /// Selection feedback.
        case selection

        /// Notification feedback of type.
        case notification(_ type: UINotificationFeedbackGenerator.FeedbackType)
    }
}
