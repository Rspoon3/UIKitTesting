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
        UICollectionViewCompositionalLayout { [weak self]
            (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            guard let self else { return nil }
            let spacing: CGFloat = 12
            let itemPeekScale: CGFloat = 0.8
            let contentWidth: CGFloat = layoutEnvironment.container.contentSize.width - (spacing * 4)
            let interGroupSpacing = -(contentWidth - (contentWidth * itemPeekScale)) / 2 + spacing
            
            // Item
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                  heightDimension: .fractionalHeight(1))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            // Group
            let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(contentWidth),
                                                   heightDimension: .absolute(contentWidth / 2))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            
            // Section
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .groupPagingCentered
            section.interGroupSpacing = interGroupSpacing
                        
            
            if #unavailable(iOS 16) {
                let horizontalInsets = section.interGroupSpacing / 2

                section.contentInsets = .init(top: 0,
                                              leading: horizontalInsets,
                                              bottom: 0,
                                              trailing: horizontalInsets)
            }
                                                
            section.visibleItemsInvalidationHandler = { [weak self] (items, offset, environment) in
                guard let self else { return }
                
                items.forEach { item in
                    let containerWidth = environment.container.contentSize.width
                    let distanceFromCenter = abs((item.frame.midX - offset.x) - containerWidth / 2.0)
                    let width = contentWidth + section.interGroupSpacing
                    
                    var percentageToMidX = 1 - (distanceFromCenter / width)
                    percentageToMidX = min(1, percentageToMidX)
                    percentageToMidX = max(0, percentageToMidX)
                    
                    let scale = itemPeekScale + (1 - itemPeekScale) * percentageToMidX
                                        
                    item.transform = CGAffineTransform(scaleX: scale,
                                                       y: scale)
                    
                    if let cell = self.collectionView.cellForItem(at: item.indexPath) as? CarouselCell {
                        cell.reflectionOpacity(percentage: percentageToMidX)
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
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
//            self.collectionView.removeFromSuperview()
//            self.collectionView = nil
//        }
    }
}
