//
//  CustomLayout.swift
//  UIKitTesting
//
//  Created by Richard Witherspoon on 12/23/22.
//

import UIKit

open class FSPagerViewLayoutAttributes: UICollectionViewLayoutAttributes {

    open var percentageToMidX: CGFloat = 0
    
    open override func isEqual(_ object: Any?) -> Bool {
        guard let object = object as? FSPagerViewLayoutAttributes else {
            return false
        }
        var isEqual = super.isEqual(object)
        isEqual = isEqual && (self.percentageToMidX == object.percentageToMidX)
        return isEqual
    }
    
    open override func copy(with zone: NSZone? = nil) -> Any {
        let copy = super.copy(with: zone) as! FSPagerViewLayoutAttributes
        copy.percentageToMidX = self.percentageToMidX
        return copy
    }
    
}


class CustomLayout: UICollectionViewCompositionalLayout {
    private let minScale: CGFloat = 0.8
    private let maxScale: CGFloat = 1
    
    open override class var layoutAttributesClass: AnyClass {
        return FSPagerViewLayoutAttributes.self
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let collectionView = collectionView else { return nil }
        let rectAttributes = super.layoutAttributesForElements(in: rect)!.map { $0.copy() as! UICollectionViewLayoutAttributes }
        let visibleRect = CGRect(origin: collectionView.contentOffset, size: collectionView.frame.size)

        for attributes in rectAttributes where attributes.frame.intersects(visibleRect) {
            let distanceFromCenter = abs((attributes.center.x - collectionView.contentOffset.x) - collectionView.frame.size.width / 2.0)

            let percentageToMidX =  1 - (distanceFromCenter / (attributes.size.width + 12))
            
            if let attributes = attributes as? FSPagerViewLayoutAttributes {
                attributes.percentageToMidX = percentageToMidX
            }

//            print(clampedScale)

//            attributes.transform = CGAffineTransform(scaleX: clampedScale, y: clampedScale)
        }

        return rectAttributes
    }
}
