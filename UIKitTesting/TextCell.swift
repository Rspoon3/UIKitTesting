//
//  TextCell.swift
//  UIKitTesting
//
//  Created by Richard Witherspoon on 6/7/22.
//

import UIKit

class TextCell: UICollectionViewCell {
    let label = UILabel()
    let bottomLabel = UILabel()
    let container = UIView()
    weak var collectionView: UICollectionView?
    
    static let reuseIdentifier = "text-cell-reuse-identifier"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    required init?(coder: NSCoder) {
        fatalError("not implemented")
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let attribute = super.preferredLayoutAttributesFitting(layoutAttributes)

        let layout = collectionView?.collectionViewLayout as! MyUICollectionViewCompositionalLayout
        let row = attribute.indexPath.row / layout.columns
      
        if let height = layout.largestDict[row] {
            attribute.frame = .init(origin: attribute.frame.origin, size: .init(width: attribute.frame.width, height: height))
        }
    
        return attribute
    }

    func configure() {
        label.numberOfLines = 0
        label.font = UIFont.preferredFont(forTextStyle: .title1)
        label.backgroundColor = .systemPurple
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        
        bottomLabel.numberOfLines = 0
        bottomLabel.font = UIFont.preferredFont(forTextStyle: .title1)
        bottomLabel.text = "Bottom of cell"
        bottomLabel.backgroundColor = .systemRed
        bottomLabel.textColor = .white
        bottomLabel.translatesAutoresizingMaskIntoConstraints = false
        bottomLabel.setContentHuggingPriority(.defaultLow, for: .vertical)
        
        contentView.addSubview(label)
        contentView.addSubview(bottomLabel)

        backgroundColor = .systemBlue.withAlphaComponent(0.75)

        let inset = CGFloat(0)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: inset),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -inset),
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: inset),

            bottomLabel.leadingAnchor.constraint(equalTo: label.leadingAnchor),
            bottomLabel.trailingAnchor.constraint(equalTo: label.trailingAnchor),
            bottomLabel.topAnchor.constraint(equalTo: label.bottomAnchor, constant: inset),
            bottomLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -inset),
        ])
    }
}
