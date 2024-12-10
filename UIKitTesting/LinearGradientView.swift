//
//  LinearGradientView.swift
//  UIKitTesting
//
//  Created by Ricky on 12/10/24.
//


import UIKit

final class LinearGradientView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupGradient()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupGradient()
    }

    private func setupGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor(red: 234 / 255, green: 249 / 255, blue: 254 / 255, alpha: 1).cgColor,
            UIColor(red: 114 / 255, green: 218 / 255, blue: 255 / 255, alpha: 1).cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)  // Top center
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)    // Bottom center
        gradientLayer.frame = bounds
        layer.insertSublayer(gradientLayer, at: 0)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.sublayers?.forEach { $0.frame = bounds }
    }
}
