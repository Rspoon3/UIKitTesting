//
//  Collection+Clostest.swift
//  UIKitTesting
//
//  Created by Ricky on 8/20/24.
//

import Foundation

extension Collection where Element: Comparable & SignedNumeric {
    func closest(to target: Element) -> Element? {
        guard !isEmpty else { return nil }
        
        var closest = self[startIndex]
        for number in self {
            if abs(number - target) < abs(closest - target) {
                closest = number
            }
        }
        return closest
    }
}
