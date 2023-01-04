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
            
            section.visibleItemsInvalidationHandler = { [weak self] (items, offset, environment) in
                guard let self else { return }
                
                items.forEach { item in
                    let spacing = manager.performSpacingCalulations(itemMidX: item.frame.midX,
                                                                    XOffset: offset.x,
                                                                    itemWidth: item.frame.width)
                    
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
        
        commonCollectionViewSetup()
    }
}
