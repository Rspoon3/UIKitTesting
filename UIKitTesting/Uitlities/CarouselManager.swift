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
    
    func performSpacingCalculations(xOffset: CGFloat, itemMidX: CGFloat) -> Spacing {
        let distanceFromCenter = abs((itemMidX - xOffset) - collectionViewWidth / 2.0)
        let width = cellWidth + interGroupSpacing
        
        var percentageToMidX = 1 - (distanceFromCenter / width)
        percentageToMidX = min(1, percentageToMidX)
        percentageToMidX = max(0, percentageToMidX)
        
        let scale = minScale + (1 - minScale) * percentageToMidX
                
        return Spacing(percentageToMidX: percentageToMidX, clampedScale: scale)
    }
}
