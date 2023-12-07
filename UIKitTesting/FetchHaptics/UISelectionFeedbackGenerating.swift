//
//  UISelectionFeedbackGenerating.swift
//  FetchRewards
//
//  Created by Richard Witherspoon on 5/9/23.
//  Copyright © 2023 Fetch Rewards, LLC. All rights reserved.
//

import UIKit

public protocol UISelectionFeedbackGenerating {
    func selectionChanged()
}

extension UISelectionFeedbackGenerator: UISelectionFeedbackGenerating {}
