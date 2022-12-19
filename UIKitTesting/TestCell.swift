//
//  TestCell.swift
//  UIKitTesting
//
//  Created by Richard Witherspoon on 12/9/22.
//

import UIKit


class TestCell: UICollectionViewCell {
    private let containerView = UIView()
    private let imageView = UIImageView()
    private let cornerRadius: CGFloat = 8

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        containerView.layer.shadowColor = UIColor.black.withAlphaComponent(1.25).cgColor
        containerView.layer.shadowRadius = 20
        containerView.layer.shadowOffset = .init(width: 0, height: 9)
        containerView.layer.shouldRasterize = true
        containerView.layer.rasterizationScale = UIScreen.main.scale
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.layer.cornerRadius = cornerRadius

        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = cornerRadius
        imageView.image = .init(named: "dog")
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(containerView)
        containerView.addSubview(imageView)
        
//        NSLayoutConstraint.activate([
//            view.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
//            view.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
//            view.heightAnchor.constraint(equalToConstant: 50),
//            view.widthAnchor.constraint(equalToConstant: 50)
//        ])
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            imageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with color: UIColor) {
        contentView.backgroundColor = color
    }
    
    func shadowOpacity(percentage: Double) {
//        view.transform = CGAffineTransform(scaleX: percentage, y: percentage)
        containerView.layer.shadowOpacity = Float(percentage)
    }
}
