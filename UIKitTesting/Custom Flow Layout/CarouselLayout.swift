//
//  CarouselLayout.swift
//  UIKitTesting
//
//  Created by Richard Witherspoon on 12/23/22.
//
import UIKit

final class CarouselLayout: UICollectionViewFlowLayout {
    private var manager = CarouselManager()
    private(set) var currentIndex = IndexPath(item: 0, section: 0)
    var startOfScrollIndex = IndexPath(item: 0, section: 0)

    
    //MARK: - Initializer
    override init() {
        super.init()

        scrollDirection = .horizontal
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Layout
    override class var layoutAttributesClass: AnyClass {
        return CarouselLayoutAttributes.self
    }

    override func prepare() {
        guard let collectionView = collectionView else { fatalError() }
        manager.collectionViewWidth = collectionView.frame.width
        
        itemSize = .init(width: manager.cellWidth,
                         height: manager.cellHeight)

        minimumLineSpacing = manager.interGroupSpacing
        
        let verticalInsets = (collectionView.frame.height - collectionView.adjustedContentInset.top - collectionView.adjustedContentInset.bottom - itemSize.height) / 2
        let horizontalInsets = (collectionView.frame.width - collectionView.adjustedContentInset.right - collectionView.adjustedContentInset.left - itemSize.width) / 2
        sectionInset = UIEdgeInsets(top: verticalInsets, left: horizontalInsets, bottom: verticalInsets, right: horizontalInsets)

        super.prepare()
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard
            let collectionView,
            let rectAttributes = super.layoutAttributesForElements(in: rect)?.compactMap ({ $0.copy() as? UICollectionViewLayoutAttributes })
        else {
            return nil
        }
        
        let visibleRect = CGRect(origin: collectionView.contentOffset, size: collectionView.frame.size)
        
        for attributes in rectAttributes where attributes.frame.intersects(visibleRect) {
            let spacing = manager.performSpacingCalculations(
                xOffset: collectionView.contentOffset.x,
                itemMidX: attributes.frame.midX
            )
            
            if let attributes = attributes as? CarouselLayoutAttributes {
                attributes.percentageToMidX = spacing.percentageToMidX
            }
            
            if spacing.clampedScale > 0.9 {
                currentIndex = attributes.indexPath
            }
            
            attributes.transform = CGAffineTransform(
                scaleX: spacing.clampedScale,
                y: spacing.clampedScale
            )
        }

        return rectAttributes
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        let targetContentOffset = super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity)
        
        guard let collectionView else {
            return targetContentOffset
        }
        
        let centerX = collectionView.bounds.width / 2.0
        let isForward = proposedContentOffset.x > collectionView.contentOffset.x
        let xVelocity = abs(velocity.x)
        var desiredAttribute: UICollectionViewLayoutAttributes?
                        
        if xVelocity == 0 {
            if currentIndex == startOfScrollIndex {
                desiredAttribute = collectionView.layoutAttributesForItem(at: startOfScrollIndex)
            } else {
                desiredAttribute = collectionView.layoutAttributesForItem(at: currentIndex)
            }
        } else if isForward {
            desiredAttribute = collectionView.layoutAttributesForItem(at: .init(item: startOfScrollIndex.item + 1, section: 0))
        } else {
            desiredAttribute = collectionView.layoutAttributesForItem(at: .init(item: startOfScrollIndex.item - 1, section: 0))
        }
        
        guard let desiredAttribute else {
            return targetContentOffset
        }
        
        return CGPoint(x: desiredAttribute.center.x - centerX, y: proposedContentOffset.y)
    }

    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        // Invalidate layout so that every cell get a chance to be zoomed when it reaches the center of the screen
        return true
    }

    override func invalidationContext(forBoundsChange newBounds: CGRect) -> UICollectionViewLayoutInvalidationContext {
        let context = super.invalidationContext(forBoundsChange: newBounds) as! UICollectionViewFlowLayoutInvalidationContext
        context.invalidateFlowLayoutDelegateMetrics = newBounds.size != collectionView?.bounds.size
        return context
    }
}
