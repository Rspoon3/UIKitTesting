//
//  UIKitTestingTests.swift
//  UIKitTestingTests
//
//  Created by Richard Witherspoon on 3/8/24.
//

import XCTest
@testable import UIKitTesting

final class AsciiLevenshteinDistanceTests: XCTestCase {
    
    // MARK: - Tests
    
    func test_Speed() {
        for query in words {
            let objcBrands = handleSearchQuery(query, swift: false)
            let swiftBrands = handleSearchQuery(query, swift: true)
            
            XCTAssertEqual(objcBrands, swiftBrands)
        }
    }
    
    private func handleSearchQuery(_ searchQuery: String, swift: Bool) -> [String] {
        return brands.sorted { brand1, brand2 in
            let brand1Lowercased = brand1.lowercased()
            let brand2Lowercased = brand2.lowercased()

            guard !searchQuery.isEmpty else {
                return brand1Lowercased < brand2Lowercased
            }
            
            let brand1Distance: Float
            let brand2Distance: Float
            
            if swift {
                brand1Distance = brand1Lowercased.asciiLevenshteinDistanceSwift(with: searchQuery)
                brand2Distance = brand2Lowercased.asciiLevenshteinDistanceSwift(with: searchQuery)
            } else {
                brand1Distance = brand1Lowercased.asciiLevenshteinDistance(with: searchQuery)
                brand2Distance = brand2Lowercased.asciiLevenshteinDistance(with: searchQuery)
            }

            if brand1Distance < brand2Distance {
                return true
            } else if brand1Distance > brand2Distance {
                return false
            } else {
                return brand1Lowercased < brand2Lowercased
            }
        }
    }
}
