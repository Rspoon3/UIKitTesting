//
//  SpreadsheetCollectionViewLayout.swift
//  UIKitTesting
//
//  Created by Richard Witherspoon on 6/27/22.
//

import UIKit

protocol TableLayoutDelegate: UICollectionViewDelegate {
    func width(forColumn column: Int, collectionView: UICollectionView) -> CGFloat
    func height(forItemAt indexPath: IndexPath, width: Double) -> CGFloat
}

protocol TableLayoutInvalidationDelegate: UICollectionViewDelegate {
    func hasFinishedInvalidating()
}

final class TableLayout: UICollectionViewLayout {
    weak var delegate: TableLayoutDelegate?
    weak var invalidationDelegate: TableLayoutInvalidationDelegate?
    private var cache = [UICollectionViewLayoutAttributes]()
    private var contentHeight: CGFloat = 0
    private var contentWidth: CGFloat = 0
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    override func prepare() {
        guard
            cache.isEmpty == true,
            let collectionView = collectionView,
            let delegate = delegate
        else {
            return
        }
        
        var previousSectionY = 0.0
        var sectionWidths: [Int: CGFloat] = [:]
        
        for section in 0..<collectionView.numberOfSections {
            var x = 0.0
            var widths: [IndexPath: Double] = [:]
            var heights = [Double]()
            let numberOfOItemsInSection = collectionView.numberOfItems(inSection: section)
            
            //Calculate all widths and heights up front
            for item in 0..<numberOfOItemsInSection {
                let indexPath = IndexPath(item: item, section: section)
                let width = delegate.width(forColumn: indexPath.row, collectionView: collectionView)
                let height = delegate.height(forItemAt: indexPath, width: width)
                
                widths[indexPath] = width
                heights.append(height)
            }
            
            
            for item in 0..<numberOfOItemsInSection {
                let indexPath = IndexPath(item: item, section: section)
                let itemWidth = widths[indexPath] ?? 0
                let maxHeight = heights.max() ?? 0
                
                let frame = CGRect(x: x,
                                   y: previousSectionY,
                                   width: itemWidth,
                                   height: maxHeight)
                
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                attributes.frame = frame
                cache.append(attributes)
                
                x += itemWidth
                
                if let value = sectionWidths[section] {
                    sectionWidths[section] = frame.width + value
                } else {
                    sectionWidths[section] = frame.width
                }
            }
            
            previousSectionY = (heights.max() ?? 0) + previousSectionY
            contentHeight = previousSectionY
        }
        
        contentWidth = sectionWidths.values.max() ?? 0
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var visibleLayoutAttributes = [UICollectionViewLayoutAttributes]()
        
        for attributes in cache {
            if attributes.frame.intersects(rect) {
                visibleLayoutAttributes.append(attributes)
            }
        }
        
        invalidationDelegate?.hasFinishedInvalidating()
        
        return visibleLayoutAttributes
    }
    
    override func invalidateLayout() {
        super.invalidateLayout()
        cache.removeAll(keepingCapacity: true)
        contentHeight = 0
        contentWidth = 0
    }
}
