//
//  Orthogonal.swift
//  UIKitTesting
//
//  Created by Richard Witherspoon on 3/1/22.
//

import UIKit

final class OrthogonalViewController: CarouselVC {
    
    //MARK: - Layout
    private func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { [weak self]
            (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            guard let self else { return nil }
            let manager = CarouselManager(collectionViewWidth: layoutEnvironment.container.contentSize.width)
            
            // Item
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                  heightDimension: .fractionalHeight(1))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            // Group
            let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(manager.cellWidth),
                                                   heightDimension: .absolute(manager.cellHeight))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            
            // Section
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .groupPagingCentered
            section.interGroupSpacing = manager.interGroupSpacing
            
            
            if #unavailable(iOS 16) {
                let horizontalInsets = manager.interGroupSpacing / 2
                
                section.contentInsets = .init(top: 0,
                                              leading: horizontalInsets,
                                              bottom: 0,
                                              trailing: horizontalInsets)
            }
                                    
            section.visibleItemsInvalidationHandler = { [weak self] (items, offset, environment) in
                guard let self else { return }
                
                items.forEach { item in
                    
                    let adjustedOffset = (offset.x + manager.spacing * 2).round(nearest: 0.5)
                    let spacing = manager.performSpacingCalulations(xOffset: adjustedOffset,
                                                                    ip: item.indexPath.item)
//                    print(adjustedOffset)
                    //
                    if item.indexPath.item == 0 {
//                        print(offset.x)
                        
                        //                        print(item.bounds.width, manager.cellWidth)
//                        print("Min x: ", item.frame.minX, item.transform, spacing.clampedScale)
//                        print("Scale: \(spacing.clampedScale)")
                    }
                                        
                    if let cell = self.collectionView.cellForItem(at: item.indexPath) as? CarouselCell {
                        cell.reflectionOpacity(percentage: spacing.percentageToMidX)
                        //cell.label.text = "\(distanceFromCenter)\n\(percentageToMidX)"
                    }
                    
                    item.transform = CGAffineTransform(scaleX: spacing.clampedScale,
                                                       y: spacing.clampedScale)
                    
                    if spacing.clampedScale > 0.9 {
                        self.currentIndex = item.indexPath
                    }
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
