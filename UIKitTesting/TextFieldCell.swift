//
//  TextFieldCell.swift
//  UIKitTesting
//
//  Created by Richard Witherspoon on 9/19/22.
//

import UIKit


class TextFieldCell: UICollectionViewCell {
    private let textField = UITextField()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .lightRandom
        addViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addViews() {
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(textField)
        
        let padding: CGFloat = 15
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            textField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding),
            textField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            textField.trailingAnchor.constraint(equalTo:  contentView.trailingAnchor, constant: -padding),
        ])
    }
    
    func configure(text: String?) {
        textField.text = text
    }
}


extension UIColor {
    static func random(alpha: CGFloat = 1.0) -> UIColor {
        let r = CGFloat.random(in: 0...1)
        let g = CGFloat.random(in: 0...1)
        let b = CGFloat.random(in: 0...1)
        
        return UIColor(red: r, green: g, blue: b, alpha: alpha)
    }
    
    static var lightRandom: UIColor {
        random(alpha: 0.3)
    }
}

