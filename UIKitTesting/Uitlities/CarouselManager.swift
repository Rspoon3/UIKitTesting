//
//  CarouselManager.swift
//  UIKitTesting
//
//  Created by Richard Witherspoon on 1/2/23.
//

import Foundation

struct CarouselManager {
    private let spacing: CGFloat = 12
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
    
    func performSpacingCalulations(itemMidX: CGFloat, XOffset: CGFloat, itemWidth: CGFloat) -> Spacing {
        let distanceFromCenter = abs((itemMidX - XOffset) - collectionViewWidth / 2.0)
        let percentageToMidX =  1 - (distanceFromCenter / (itemWidth + spacing))
        let scale = ((maxScale - minScale) * percentageToMidX) + minScale
        let clampedScale = max(minScale, scale)
        
        return Spacing(percentageToMidX: percentageToMidX, clampedScale: clampedScale)
    }
}
