//
//  Orthogonal.swift
//  UIKitTesting
//
//  Created by Richard Witherspoon on 3/1/22.
//

import UIKit

final class OrthogonalViewController: CarouselVC {
    
    private func lerp(from pointOne: Double, to pointTwo: Double, percentage: Double) -> Double {
        
        /// Keep the percentage variable within the 0.0 -> 1.0 range
        var percentage = percentage
        percentage = min(1, percentage)
        percentage = max(0, percentage)
        
        let resultPoint = pointOne + (pointTwo - pointOne) * percentage
        
        return resultPoint
    }
    
    //MARK: - Layout
    private func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { [weak self]
            (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            guard let self else { return nil }
            let itemPeekSize:CGFloat = 12
            let itemSpacing:CGFloat = 12
            let contentPadding: CGFloat = itemPeekSize + itemSpacing
            let itemPeekScale: CGFloat = 0.8
            let contentWidth: CGFloat = layoutEnvironment.container.contentSize.width - (contentPadding * 2)
            let scaledContentWidth: CGFloat = contentWidth * itemPeekScale
            let sizeDifference: CGFloat = contentWidth - scaledContentWidth
            let scaledOffset: CGFloat = sizeDifference / 2
            
            // Item
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                  heightDimension: .fractionalHeight(1))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            // Group
            let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(contentWidth),
                                                   heightDimension: .absolute(contentWidth/2))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            
            // Section
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .groupPagingCentered
            section.interGroupSpacing = itemPeekSize - scaledOffset
            
            print("section.interGroupSpacing: ", section.interGroupSpacing)
            
            
//            if #unavailable(iOS 16) {
//                let horizontalInsets = manager.interGroupSpacing / 2
//
//                section.contentInsets = .init(top: 0,
//                                              leading: horizontalInsets,
//                                              bottom: 0,
//                                              trailing: horizontalInsets)
//            }
                                                
            section.visibleItemsInvalidationHandler = { [weak self] (items, offset, environment) in
                guard let self else { return }
                
                items.forEach { item in
                    
                    var coerceIn = offset.x
                    
                    if coerceIn < 0 {
                        coerceIn = 0
                    } else if coerceIn > 1 {
                        coerceIn = 1
                    }
                    
                    let fraction = 1 - coerceIn
//                    let lerp = itemPeekScale + (1 - itemPeekScale) * fraction
                    
                    let lerp = self.lerp(from: itemPeekScale, to: 1, percentage: fraction)
                    
                    if item.indexPath.item == 1 {
                        print(fraction, lerp)
                    }
                    
                    item.transform = CGAffineTransform(scaleX: lerp,
                                                       y: lerp)
                    
                    
//                    lerp(
//                        start = itemPeekScale,
//                        stop = 1f,
//                        fraction = 1f - pageOffset.coerceIn(0f, 1f)
//                    ).also { scale ->
//                        scaleY = scale
//                        scaleX = scale
//                    }
//
//                    if let cell = self.collectionView.cellForItem(at: item.indexPath) as? CarouselCell {
//                        cell.reflectionOpacity(percentage: spacing.percentageToMidX)
//                    }
//
//                    item.transform = CGAffineTransform(scaleX: spacing.clampedScale,
//                                                       y: spacing.clampedScale)
//
//                    if spacing.clampedScale > 0.9 {
//                        self.currentIndex = item.indexPath
//                    }
                }
            }
            
            return section
        }
    }
    
    override func configureCollectionView() {
        collectionView = OrthogonalUICollectionView(frame: view.bounds,
                                                    collectionViewLayout: createLayout())
        
        if let collectionView = collectionView as? OrthogonalUICollectionView {
            collectionView.didStartDragging = { [weak self] in
                self?.stopTimer()
            }
        }
        
        commonViewSetup()
    }
}


extension CGFloat {
    func round(nearest: CGFloat) -> CGFloat {
        let n = 1/nearest
        let numberToRound = self * n
        return numberToRound.rounded() / n
    }

    func floor(nearest: CGFloat) -> CGFloat {
        let intDiv = CGFloat(Int(self / nearest))
        return intDiv * nearest
    }
}
