//
//  WaterfallLayout.swift
//  UIKitTesting
//
//  Created by Richard Witherspoon on 11/18/22.
//

import UIKit


protocol WaterfallLayoutDelegate: AnyObject {
    func heightForItem(at indexPath: IndexPath) -> CGFloat
}

class WaterfallLayout: UICollectionViewFlowLayout {
    weak var delegate: WaterfallLayoutDelegate?
    var contentBounds = CGRect.zero
    var cachedAttributes = [Int: [UICollectionViewLayoutAttributes]]()
    
    /// - Tag: PrepareMosaicLayout
    override func prepare() {
        super.prepare()
        
        guard let collectionView = collectionView else { return }
        let numberOfSections = collectionView.numberOfSections
        let cvWidth = collectionView.bounds.size.width
        let padding: CGFloat = 10

        cachedAttributes.removeAll()
        contentBounds = CGRect(origin: .zero, size: collectionView.bounds.size)
        
        for section in 0..<numberOfSections {
            let itemCount = collectionView.numberOfItems(inSection: section)
            
            var lastFrame: CGRect = .zero
            
            cachedAttributes[section] = []
            
            for currentIndex in 0..<itemCount {
                var x: CGFloat = 0
                
                if section > 0 {
                    x = (cvWidth / CGFloat(numberOfSections)) * CGFloat(section)
                }
                
                let indexPath = IndexPath(item: currentIndex, section: section)
                let segmentFrame = CGRect(x: x,
                                          y: lastFrame.maxY + padding,
                                          width: (cvWidth / CGFloat(numberOfSections)) - padding,
                                          height: section == 0 ? 200 : delegate?.heightForItem(at: indexPath) ?? 0)
                
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                attributes.frame = segmentFrame
                
                cachedAttributes[section]?.append(attributes)
                contentBounds.size.height = max(contentBounds.size.height, segmentFrame.maxY + padding)
                
                lastFrame = segmentFrame
            }
        }
    }

    override var collectionViewContentSize: CGSize {
        return contentBounds.size
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        guard let collectionView = collectionView else { return false }
        return !newBounds.size.equalTo(collectionView.bounds.size)
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cachedAttributes[indexPath.section]?[indexPath.item]
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let allCachedAttributes = cachedAttributes.flatMap(\.value)
        
        return allCachedAttributes.filter{rect.intersects($0.frame) }
    }
}
