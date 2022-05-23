//
//  IndentCell.swift
//  UIKitTesting
//
//  Created by Richard Witherspoon on 5/23/22.
//

import UIKit

class IndentCell: UICollectionViewCell{
    private let textLabel = UILabel()
    private let container = UIView()
    private let padding: CGFloat = 15
    private let spacing: CGFloat = 40
    private var leadingConstraint: NSLayoutConstraint! = nil
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(text: String, indentLevel: Int, color: UIColor) {
        textLabel.text = text
        textLabel.textColor = color
        
        leadingConstraint.isActive = false
        leadingConstraint = container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                                               constant: CGFloat(indentLevel) * spacing + padding)
        leadingConstraint.isActive = true
    }
    
    private func addViews(){
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.font = .preferredFont(forTextStyle: .headline)
        
        container.backgroundColor = .systemGray6
        container.translatesAutoresizingMaskIntoConstraints = false
        
        container.addSubview(textLabel)
        contentView.addSubview(container)
        
        leadingConstraint = container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor)

        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: contentView.topAnchor),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            leadingConstraint,
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            
            textLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: padding),
            textLabel.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -padding),
            textLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: padding),
            textLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -padding),
        ])
    }
}
