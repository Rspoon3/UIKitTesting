//
//  RadialGradientView.swift
//  UIKitTesting
//
//  Created by Ricky on 12/9/24.
//

import Foundation
import UIKit
import UIKit

final class RadialGradientView: UIView {
    private let gradientLayer = RadialGradientLayer()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupGradient()
        setupShadows()
        
        layer.cornerRadius = 8
        clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        nil
    }
    
    private func setupGradient() {
        gradientLayer.colors = [
            UIColor(red: 1.0, green: 0.07, blue: 0.8, alpha: 1.0).cgColor,
            UIColor(red: 0.38, green: 0.05, blue: 0.38, alpha: 1.0).cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0.6652, y: 0.8315)
        gradientLayer.radius = 300
        layer.insertSublayer(gradientLayer, at: 0)
    }

    private func setupShadows() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.04
        layer.shadowRadius = 2
        layer.shadowOffset = CGSize(width: 0, height: 0)

        // Add second shadow effect
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.08
        layer.shadowRadius = 10
        layer.shadowOffset = CGSize(width: 0, height: 2)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
        gradientLayer.setNeedsDisplay()
    }
}

// Custom radial gradient layer
final class RadialGradientLayer: CALayer {
    var colors: [CGColor] = []
    var startPoint: CGPoint = .zero
    var radius: CGFloat = 0

    override func draw(in ctx: CGContext) {
        guard let gradient = CGGradient(
            colorsSpace: CGColorSpaceCreateDeviceRGB(),
            colors: colors as CFArray,
            locations: nil
        ) else {
            return
        }

        let center = CGPoint(
            x: bounds.width * startPoint.x,
            y: bounds.height * startPoint.y
        )
        ctx.drawRadialGradient(
            gradient,
            startCenter: center,
            startRadius: 0,
            endCenter: center,
            endRadius: radius,
            options: .drawsAfterEndLocation
        )
    }
}
