//
//  Notification+Name.swift
//  UIKitTesting
//
//  Created by Richard Witherspoon on 8/31/23.
//

import Foundation
import UIKit

extension Notification.Name {
    public static let tokenRefreshed = Notification.Name("tokenRefreshed")
}


extension String {
    func asciiLevenshteinDistance(
        with stringB: String,
        skipping charset: CharacterSet? = nil
    ) -> Float {
        let stringA: String
        var stringB = stringB
        
        if let charset {
            stringA = self.components(separatedBy: charset).joined(separator: "")
            stringB = stringB.components(separatedBy: charset).joined(separator: "")
        } else {
            stringA = self
        }
        
        guard
            let dataA = self.data(using: .ascii, allowLossyConversion: true),
            let dataB = stringB.data(using: .ascii, allowLossyConversion: true)
        else {
            return 0.0
        }
        
        let cstringA = [UInt8](dataA)
        let cstringB = [UInt8](dataB)
        
        let n = dataA.count + 1
        let m = dataB.count + 1
        
        var d = [Int](repeating: 0, count: n * m)
        
        for k in 0..<n {
            d[k] = k
        }
        
        for k in 0..<m {
            d[k * n] = k
        }
        
        for i in 1..<n {
            for j in 1..<m {
                let cost: Int
                
                if cstringA[i - 1] == cstringB[j - 1] {
                    cost = 0
                } else {
                    cost = 1
                }
                
                d[j * n + i] = smallestOf(d[(j - 1) * n + i] + 1,
                                          d[j * n + i - 1] + 1,
                                          d[(j - 1) * n + i - 1] + cost)
            }
        }
        
        let distance = d[n * m - 1]
        
        return Float(distance)
    }
    
    private func smallestOf(_ a: Int, _ b: Int, _ c: Int) -> Int {
        var min = a
        if b < min {
            min = b
        }
        
        if c < min {
            min = c
        }
        
        return min
    }
}





final class EvenGridLayout: UICollectionViewLayout {
    var itemRects: [[CGRect]] = []
    var contentSize: CGSize = .zero
    
    var margin: CGFloat = 8
    var maxCellSize: CGFloat = 240.0
    var leftRightPadding: CGFloat = 0
    var itemsPerRow: Int = 2
    
    var allSectionsFullWidth = false
    var defaultAspect: CGFloat = 1.0
    var universalRowHeightOverride: CGFloat = 0.0
    var firstSectionForceHeight: CGFloat = 0.0
    var firstSectionAspect: CGFloat = 0
    var firstSectionFullWidth: Bool = false
    var rowHeightOverrides: [Int] = []
    
    
}
