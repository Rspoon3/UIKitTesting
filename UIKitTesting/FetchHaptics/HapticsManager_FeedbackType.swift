//
//  HapticsManager_FeedbackType.swift
//  FetchHop
//
//  Created by Gray Campbell on 9/21/21.
//  Copyright © 2021 Fetch Rewards, LLC. All rights reserved.
//

import UIKit

/// Feedback type for one-off haptics that don't call `prepare()`.
public enum FeedbackType: Equatable {
    
    /// Impact feedback with style and optional intensity.
    case impact(_ style: UIImpactFeedbackGenerator.FeedbackStyle, intensity: CGFloat? = nil)
    
    /// Selection feedback.
    case selection
    
    /// Notification feedback of type.
    case notification(_ type: UINotificationFeedbackGenerator.FeedbackType)
}

/// Feedback type for creating a new feedback generator managed by the haptics manager.
public enum FeedbackCreationType: Equatable {
    
    /// Impact feedback with style.
    case impact(_ style: UIImpactFeedbackGenerator.FeedbackStyle)
    
    /// Selection feedback.
    case selection
    
    /// Notification feedback.
    case notification
}

/// Feedback type for generating feedback from a generator managed by the haptics manager.
public enum FeedbackGenerationType: Equatable {
    
    /// Impact feedback with optional intensity.
    case impact(intensity: CGFloat? = nil)
    
    /// Selection feedback.
    case selection
    
    /// Notification feedback of type.
    case notification(_ type: UINotificationFeedbackGenerator.FeedbackType)
}
