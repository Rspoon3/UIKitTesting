//
//  UICollectionViewCellRegistration+Demo.swift
//  UIKitTesting
//
//  Created by Ricky on 8/20/24.
//

import UIKit

extension UICollectionView.CellRegistration {
    static func demo() -> UICollectionView.CellRegistration<TextCell, String> {
        let cellRegistration = UICollectionView.CellRegistration<TextCell, String> { (cell, indexPath, item) in
            cell.contentView.backgroundColor = .systemBlue
            cell.label.text = item
            cell.label.textColor = .white
        }
        return cellRegistration
    }
}
