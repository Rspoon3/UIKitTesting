//
//  UIKitTestingTests.swift
//  UIKitTestingTests
//
//  Created by Richard Witherspoon on 8/31/23.
//

import XCTest
@testable import UIKitTesting

final class LevenshteinTests: XCTestCase {
    
    func testAsciiLevenshteinDistance() {
        XCTAssertEqual(2, 2)
        
        let firstLowercased = "ASdfasdf".lowercased()
        
        var filter = "string"
        var firstDistance = "This is a string".asciiLevenshteinDistance(with: filter)
        var secondDistance = "This is a string".asciiLevenshteinDistance(with: filter)
        
        filter = "test"
        firstDistance = "This is a string test".asciiLevenshteinDistance(with: filter)
        secondDistance = "This is a string".asciiLevenshteinDistance(with: filter)
    }
}
