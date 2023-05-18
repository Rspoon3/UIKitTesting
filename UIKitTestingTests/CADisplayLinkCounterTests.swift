//
//  CADisplayLinkCounterTests.swift
//  CADisplayLinkCounterTests
//
//  Created by Richard Witherspoon on 5/18/23.
//

import XCTest
@testable import UIKitTesting

@MainActor final class CADisplayLinkCounterTests: XCTestCase {
    private let startValue: Double = 0
    private let endValue: Double = 100_000
    
    func testCount() async {
        for method in CADisplayLinkCounter.CountingMethod.allCases {
            var numbers: [Double] = []
            let counterSequence = CADisplayLinkCounter.count(
                from: 0,
                to: endValue,
                duration: 0.1,
                method: method
            )
            
            for await value in counterSequence {
                numbers.append(value)
            }
            
            XCTAssertEqual(numbers.first, startValue)
            XCTAssertEqual(numbers.last, endValue)
        }
    }
}
