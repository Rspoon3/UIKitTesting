//
//  LabelCell.swift
//  UIKitTesting
//
//  Created by Richard Witherspoon on 6/13/22.
//

import UIKit

class TextItemCell: UICollectionViewCell {
    let label = UILabel()
    static let reuseIdentifier = "label-cell-reuse-identifier"
    var indexPath: IndexPath?

    
    //MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        addViews()
        
        layer.borderColor = UIColor.systemGray.withAlphaComponent(0.1).cgColor
        layer.borderWidth = 1
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("not implemented")
    }
    
    
    //MARK: - Helpers
    func configure(item: TextItem, backgroundColor: UIColor){
        label.text = item.text
        self.backgroundColor = backgroundColor
        
        if item.bold {
            label.font = UIFont.preferredFont(forTextStyle: .headline)
        } else {
            label.font = UIFont.preferredFont(forTextStyle: .body)
        }
    }
    

    //MARK: - Private Helpers
    private func addViews() {
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        
        contentView.addSubview(label)

        let inset = CGFloat(10)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: inset),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -inset),
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: inset),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -inset),
        ])
    }
}
