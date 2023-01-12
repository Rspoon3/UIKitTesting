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


        if ip == 1 {
            print(itemMidX, distanceFromCenter, scale)
//            print(distanceFromCenter, itemWidth + interGroupSpacing)
            
//            print(distanceFromCenter, XOffset, itemMidX)
//            print(itemWidth, spacing, collectionViewWidth, clampedScale, scale, itemMidX, XOffset, distanceFromCenter)
//            print(scale, distanceFromCenter, percentageToMidX)
//            print(distanceFromCenter, percentageToMidX, scale, clampedScale) //50000 0, 1234, 306
        }
                
        return Spacing(percentageToMidX: 0.5, clampedScale: scale)
    }
}
//itemWidth 976


