//
//  Builder.swift
//
//
//  Created by Richard Witherspoon on 11/2/23.
//

import UIKit

/// An object which creates confetti core animation layers.
final class Builder {
    func createConfettiCells() -> [CAEmitterCell] {
        return confettiTypes.map { confettiType in
            let cell = CAEmitterCell()
            cell.name = confettiType.name

            cell.beginTime = 0.1
            cell.birthRate = 100
            cell.contents = confettiType.image.cgImage
            cell.emissionRange = CGFloat(Double.pi)
            cell.lifetime = 10
            cell.spin = 4
            cell.spinRange = 8
            cell.velocityRange = 0
            cell.yAcceleration = 0

            let halfPie = Double.pi / 2
            cell.setValue("plane", forKey: "particleType")
            cell.setValue(Double.pi, forKey: "orientationRange")
            cell.setValue(halfPie, forKey: "orientationLongitude")
            cell.setValue(halfPie, forKey: "orientationLatitude")

            return cell
        }
    }

    func createConfettiLayer(bounds: CGRect) -> CAEmitterLayer {
        let emitterLayer = CAEmitterLayer()

        emitterLayer.birthRate = 0
        emitterLayer.emitterCells = createConfettiCells()
        emitterLayer.emitterPosition = CGPoint(x: bounds.midX, y: bounds.minY - 100)
        emitterLayer.emitterSize = CGSize(width: 100, height: 100)
        emitterLayer.emitterShape = .sphere
        emitterLayer.frame = bounds

        emitterLayer.beginTime = CACurrentMediaTime()
        return emitterLayer
    }

    lazy var confettiTypes: [ConfettiType] = {
        ConfettiType.Position.allCases.flatMap { position in
            confettiShapes.flatMap { shape in
                confettiColors.map { color in
                    ConfettiType(color: color, shape: shape, position: position)
                }
            }
        }
    }()
    
    var confettiColors: [UIColor] {
        [
            (r: 149, g: 58, b: 255), (r: 255, g: 195, b: 41), (r: 255, g: 101, b: 26),
            (r: 123, g: 92, b: 255), (r: 76, g: 126, b: 255), (r: 71, g: 192, b: 255),
            (r: 255, g: 47, b: 39), (r: 255, g: 91, b: 134), (r: 233, g: 122, b: 208)
        ].map {
            UIColor(
                red: $0.r / 255.0,
                green: $0.g / 255.0,
                blue: $0.b / 255.0,
                alpha: 1
            )
        }
    }

    var confettiShapes: [ConfettiType.Shape] {
        [ConfettiType.Shape.rectangle, ConfettiType.Shape.circle]
    }
}
