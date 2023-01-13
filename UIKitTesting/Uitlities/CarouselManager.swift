//
//  CarouselManager.swift
//  UIKitTesting
//
//  Created by Richard Witherspoon on 1/2/23.
//

import Foundation
import UIKit

struct CarouselManager {
    let spacing: CGFloat = 12
    private let maxScale: CGFloat = 1
    private let minScale: CGFloat = 0.8
    var collectionViewWidth: CGFloat
    
    
    //MARK: - Initializer
    
    init(collectionViewWidth: CGFloat = 0) {
        self.collectionViewWidth = collectionViewWidth
    }
    
    struct Spacing {
        let percentageToMidX: CGFloat
        let clampedScale: CGFloat
    }
    
    var cellWidth: CGFloat {
        collectionViewWidth - spacing * 4
    }
    
    var cellHeight: CGFloat {
        cellWidth / 2
    }
    
    var interGroupSpacing: CGFloat {
        let interGroupSpacing = -(cellWidth - (cellWidth * minScale)) / 2
        return interGroupSpacing + spacing
    }
    
    
    //MARK: - Public Helpers
    
    func performSpacingCalulations(xOffset: CGFloat, ip: Int) -> Spacing {
        let s = cellWidth + interGroupSpacing
        let itemMidX = (CGFloat(ip) * s) + cellWidth/2
        let distanceFromCenter = abs((itemMidX - xOffset + spacing * 2) - collectionViewWidth / 2.0)
        let percentageToMidX = 1 - (distanceFromCenter / s)
        let scale = ((maxScale - minScale) * percentageToMidX) + minScale
        var clampedScale = max(minScale, scale)
        clampedScale = round(clampedScale * 1000) / 1000.0

        

        if ip == 1 {
//            print(distanceFromCenter, itemWidth + interGroupSpacing)
            
//            print(distanceFromCenter, XOffset, itemMidX)
//            print(itemWidth, spacing, collectionViewWidth, clampedScale, scale, itemMidX, XOffset, distanceFromCenter)
//            print(scale, distanceFromCenter, percentageToMidX)
//            print(distanceFromCenter, percentageToMidX, scale, clampedScale) //50000 0, 1234, 306
        }
                
        return Spacing(percentageToMidX: 0.5, clampedScale: clampedScale)
    }
}
