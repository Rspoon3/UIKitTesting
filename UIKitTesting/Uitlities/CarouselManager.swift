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
        let value = interGroupSpacing + spacing
        let roundedValue = round(value * 1000) / 1000.0
        return roundedValue
    }
    
    
    //MARK: - Public Helpers
    
    func performSpacingCalulations(xOffset: CGFloat, ip: Int) -> Spacing {
//        let distanceFromCenter = abs(adjustedItemMidX - collectionViewWidth / 2.0) //good
//        let distanceFromCenter = abs(adjustedItemMidX - (cellWidth + interGroupSpacing)) //good
//
//
//        let percentageToMidX =  1 - (distanceFromCenter / (itemWidth - spacing * 2)) //good
//        let percentageToMidX = 1 - (distanceFromCenter / (cellWidth - interGroupSpacing))
//        var scale = ((maxScale - minScale) * percentageToMidX) + minScale
//        scale = round(scale * 1000) / 1000.0
        
//        if clampedScale < 0.82 {
//            clampedScale = 0.8
//        } else if clampedScale > 0.98 {
//            clampedScale = 1
//        }
        
        //intergroup spacing = -85.6
        //item width (0.8 scale) = 780.8
        //item width = 976
        //item width (half) = 488
        //512 + 378.5 = 890.5
        //976 - 780.8 = 195.2
        //distanceFromCenter = 890.5

        //collectionViewWidth = 393
        //collectionViewWidth / 2 = 196.5
        //intergroup spacing = 22.5
        //item width (0.8 scale) = 276
        //item width = 345
        //item width (half) = 172.5
        //distanceFromCenter = 322.666667
        //345 - 22.5 = 322.5
        //345 - 276 = 69
        
        
        let s = cellWidth + interGroupSpacing
        let itemMidX = (CGFloat(ip) * s) + cellWidth/2
        
        
//        let percent = 1 - (xOffset / (itemMidX - 172.5))
//        let scale = ((maxScale - minScale) * percent) + minScale
//        let clampedScale = max(minScale, scale)

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
