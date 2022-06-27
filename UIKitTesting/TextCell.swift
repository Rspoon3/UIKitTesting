//
//  TextCell.swift
//  UIKitTesting
//
//  Created by Richard Witherspoon on 6/13/22.
//

import UIKit

class TextCell: UICollectionViewCell {
    let textView = UITextView()
    static let reuseIdentifier = "text-cell-reuse-identifier"
    weak var delegate: UITextViewDelegate?
    var indexPath: IndexPath?

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    required init?(coder: NSCoder) {
        fatalError("not implemented")
    }

    private func configure() {
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont.preferredFont(forTextStyle: .title2)
        textView.isScrollEnabled = false
        
        contentView.addSubview(textView)

        let inset = CGFloat(10)
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: inset),
            textView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -inset),
            textView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: inset),
            textView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -inset),
        ])
    }
}

class ButtonCell: UICollectionViewCell {
    let button = UIButton()
    static let reuseIdentifier = "button-cell-reuse-identifier"
    var buttonAction : (()->Void)?


    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("not implemented")
    }

    private func configure() {
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Button", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        
        button.addAction(.init(handler: { [weak self] _ in
            self?.buttonAction?()
        }), for: .touchUpInside)
        
        contentView.addSubview(button)

        let inset = CGFloat(10)
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: contentView.topAnchor, constant: inset),
            button.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -inset),
            button.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: inset),
            button.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -inset),
        ])
    }
}
