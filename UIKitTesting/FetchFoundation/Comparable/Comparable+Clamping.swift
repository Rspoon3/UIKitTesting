//
//  Comparable+Clamping.swift
//  FetchHop
//
//  Created by Gray Campbell on 6/9/21.
//  Copyright © 2021 Fetch Rewards, LLC. All rights reserved.
//

import Foundation

extension Comparable {
    
    /// Clamps the value to the specified bounds.
    ///
    /// - Parameter bounds: A closed range specifying the upper and lower bounds to which the value should be clamped.
    ///
    /// - Returns: The lower bound if greater than the value, the upper bound if less than the value, or the value as is if it falls within the bounds provided.
    public func clamped(to bounds: ClosedRange<Self>) -> Self {
        min(max(self, bounds.lowerBound), bounds.upperBound)
    }
}
