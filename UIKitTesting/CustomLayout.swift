//
//  CustomLayout.swift
//  UIKitTesting
//
//  Created by Richard Witherspoon on 12/23/22.
//

import UIKit

class CustomLayout: UICollectionViewCompositionalLayout {
    private let minScale: CGFloat = 0.8
    private let maxScale: CGFloat = 1

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let collectionView = collectionView else { return nil }
        let rectAttributes = super.layoutAttributesForElements(in: rect)!.map { $0.copy() as! UICollectionViewLayoutAttributes }
        let visibleRect = CGRect(origin: collectionView.contentOffset, size: collectionView.frame.size)

        for attributes in rectAttributes where attributes.frame.intersects(visibleRect) {
            let distanceFromCenter = abs((attributes.center.x - collectionView.contentOffset.x) - collectionView.frame.size.width / 2.0)

            let percentageToMidX =  1 - (distanceFromCenter / (attributes.size.width + 12))
            let scale = ((self.maxScale - self.minScale) * percentageToMidX) + self.minScale
            let clampedScale = max(self.minScale, scale)

//            print(clampedScale)

            attributes.transform = CGAffineTransform(scaleX: clampedScale, y: clampedScale)
        }
        
        print(rectAttributes)

        return rectAttributes
    }

    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        // Invalidate layout so that every cell get a chance to be zoomed when it reaches the center of the screen
        return true
    }

//    override func invalidationContext(forBoundsChange newBounds: CGRect) -> UICollectionViewLayoutInvalidationContext {
//        let context = super.invalidationContext(forBoundsChange: newBounds) as! UICollectionViewFlowLayoutInvalidationContext
//        context.invalidateFlowLayoutDelegateMetrics = newBounds.size != collectionView?.bounds.size
//        return context
//    }
}
