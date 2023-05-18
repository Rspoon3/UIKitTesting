//
//  CADisplayLinkCounterMethod.swift
//  UIKitTesting
//
//  Created by Richard Witherspoon on 5/18/23.
//

import Foundation

extension CADisplayLinkCounter {
    
    /// The counting method that CADisplayLinkCounter will use
    enum CountingMethod: CaseIterable {
        private static let rate: Double = 3
        
        case linear
        case easeIn
        case easeOut
        case easeInOut
        case easeInBounce
        case easeOutBounce
        
        func value(from percentage: Double) -> Double {
            switch self {
            case .linear:
                return percentage
            case .easeIn:
                return pow(percentage, CountingMethod.rate)
            case .easeOut:
                return 1.0 - pow((1.0 - percentage), CountingMethod.rate)
            case .easeInOut:
                return easeInOutCalculation(percentage)
            case .easeInBounce:
                return easeInBounceCalculation(percentage)
            case .easeOutBounce:
                return easeOutBounceCalculation(percentage)
            }
        }
        
        private func easeInOutCalculation(_ percentage: Double) -> Double {
            let value = percentage * 2
            
            if value < 1 {
                return 0.5 * pow(value, CountingMethod.rate)
            } else {
                return 0.5 * (2.0 - pow(2.0 - value, CountingMethod.rate))
            }
        }
        
        private func easeInBounceCalculation(_ percentage: Double) -> Double {
            if percentage < 4.0 / 11.0 {
                return 1.0 - (pow(11.0 / 4.0, 2) * pow(percentage, 2)) - percentage
            } else if percentage < 8.0 / 11.0 {
                return 1.0 - (3.0 / 4.0 + pow(11.0 / 4.0, 2) * pow(percentage - 6.0 / 11.0, 2)) - percentage
            } else if percentage < 10.0 / 11.0 {
                return 1.0 - (15.0 / 16.0 + pow(11.0 / 4.0, 2) * pow(percentage - 9.0 / 11.0, 2)) - percentage
            } else {
                return 1.0 - (63.0 / 64.0 + pow(11.0 / 4.0, 2) * pow(percentage - 21.0 / 22.0, 2)) - percentage
            }
        }
        
        private func easeOutBounceCalculation(_ percentage: Double) -> Double {
            if percentage < 4.0 / 11.0 {
                return pow(11.0 / 4.0, 2) * pow(percentage, 2)
            } else if percentage < 8.0 / 11.0 {
                return 3.0 / 4.0 + pow(11.0 / 4.0, 2) * pow(percentage - 6.0 / 11.0, 2)
            } else if percentage < 10.0 / 11.0 {
                return 15.0 / 16.0 + pow(11.0 / 4.0, 2) * pow(percentage - 9.0 / 11.0, 2)
            } else {
                return 63.0 / 64.0 + pow(11.0 / 4.0, 2) * pow(percentage - 21.0 / 22.0, 2)
            }
        }
    }
}
