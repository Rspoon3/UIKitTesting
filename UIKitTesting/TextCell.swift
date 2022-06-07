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
    static let reuseIdentifier = "text-cell-reuse-identifier"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    required init?(coder: NSCoder) {
        fatalError("not implemented")
    }
    

    func configure() {
        label.numberOfLines = 0
        label.adjustsFontForContentSizeCategory = true
        label.font = UIFont.preferredFont(forTextStyle: .title1)
        label.backgroundColor = .systemPurple
        label.textColor = .white

        
        bottomLabel.numberOfLines = 0
        bottomLabel.adjustsFontForContentSizeCategory = true
        bottomLabel.font = UIFont.preferredFont(forTextStyle: .title1)
        bottomLabel.text = "Bottom of cell"
        bottomLabel.backgroundColor = .systemRed
        bottomLabel.textColor = .white
        
        
        let stack = UIStackView(arrangedSubviews: [label, bottomLabel])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        stack.spacing = 20
        contentView.addSubview(stack)

        backgroundColor = .systemBlue.withAlphaComponent(0.75)

        let inset = CGFloat(10)
        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: inset),
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -inset),
            stack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: inset),
            stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -inset),
        ])
    }
}
