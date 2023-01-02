//
//  CarouselLayoutAttributes.swift
//  UIKitTesting
//
//  Created by Richard Witherspoon on 12/31/22.
//

import UIKit

final class CarouselLayoutAttributes: UICollectionViewLayoutAttributes {

    var percentageToMidX: CGFloat = 0
    
    override func isEqual(_ object: Any?) -> Bool {
        guard let object = object as? CarouselLayoutAttributes else {
            return false
        }
        var isEqual = super.isEqual(object)
        isEqual = isEqual && (self.percentageToMidX == object.percentageToMidX)
        return isEqual
    }
    
    override func copy(with zone: NSZone? = nil) -> Any {
        let copy = super.copy(with: zone) as! CarouselLayoutAttributes
        copy.percentageToMidX = self.percentageToMidX
        return copy
    }
}
