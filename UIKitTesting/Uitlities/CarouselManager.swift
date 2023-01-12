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
//itemWidth 976

//15
//Start -22.2 342.0
//490.8 295.8 0.8150093808630394 0.815
//490.8 330.79999999999995 0.7931207004377737 0.8
//2023-01-12 03:30:55.549257-0500 UIKitTesting[14735:4734653] Metal API Validation Enabled
//490.8 11.300000000000011 0.9929330831769856 0.993
//Start -22.2 342.0
//490.8 11.300000000000011 0.9929330831769856 0.993
//Start -22.2 342.0
//490.8 11.300000000000011 0.9929330831769856 0.993

//Start -22.2 342.0
//Start -22.2 342.0
//0.0
//2023-01-12 03:35:36.823334-0500 UIKitTesting[15554:4754777] Metal API Validation Enabled
//-35.0
//2023-01-12 03:35:37.023914-0500 UIKitTesting[15554:4754777] [UICollectionViewRecursion] cv == 0x13c0a5e00 Disabling recursion trigger logging


//16
//Start -22.2 342.0
//490.8 295.8 0.8150093808630394 0.815
//490.8 319.79999999999995 0.8 0.8
//2023-01-12 03:31:21.695024-0500 UIKitTesting[14810:4736724] Metal API Validation Enabled
//490.8 0.30000000000001137 0.999812382739212 1.0
//Start -22.2 342.0
//490.8 0.30000000000001137 0.999812382739212 1.0


//Start -22.2 342.0
//0.0
//2023-01-12 03:35:14.485467-0500 UIKitTesting[15495:4753303] Metal API Validation Enabled
//-24.0
