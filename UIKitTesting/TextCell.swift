//
//  TextCell.swift
//  UIKitTesting
//
//  Created by Richard Witherspoon on 6/7/22.
//

import UIKit

class TextCell: UICollectionViewCell {
    private let label = UILabel()
    weak private var layout: EqualHeightsUICollectionViewCompositionalLayout?

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBlue.withAlphaComponent(0.75)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("not implemented")
    }

    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let attribute = super.preferredLayoutAttributesFitting(layoutAttributes)
        layout?.updateLayoutAttributesHeight(layoutAttributes: attribute)
        return attribute
    }
    
    
    func configure(text: String, layout: EqualHeightsUICollectionViewCompositionalLayout?) {
        label.text = text
        self.layout = layout
    }
    
    private func configure() {
        let bottomLabel = UILabel()
        
        label.numberOfLines = 0
        label.font = UIFont.preferredFont(forTextStyle: .title1)
        label.backgroundColor = .systemPurple
        label.textColor = .white
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        
        bottomLabel.numberOfLines = 0
        bottomLabel.font = UIFont.preferredFont(forTextStyle: .title1)
        bottomLabel.text = "Bottom of cell"
        bottomLabel.backgroundColor = .systemRed
        bottomLabel.textColor = .white
        bottomLabel.setContentHuggingPriority(.defaultLow, for: .vertical)
        
        let stackView = UIStackView(arrangedSubviews: [label, bottomLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 20

        contentView.addSubview(stackView)
        
        let padding: CGFloat = 15
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            stackView.trailingAnchor.constraint(equalTo:  contentView.trailingAnchor, constant: -padding),
        ])
    }
}
