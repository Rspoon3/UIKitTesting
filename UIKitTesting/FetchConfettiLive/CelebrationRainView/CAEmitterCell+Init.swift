//
//  CAEmitterCell+Init.swift
//  UIKitTesting
//
//  Created by Richard Witherspoon on 12/7/23.
//

import UIKit

internal extension CAEmitterCell {
    convenience init(
        birthrate: Float,
        image: CGImage?
    ) {
        self.init()
        birthRate = birthrate
        beginTime = CACurrentMediaTime() + Double.random(in: 0..<1)
        lifetime = 15
        velocity = 200
        velocityRange = 20
        emissionLongitude = CGFloat(Double.pi)
        spinRange = 20
        yAcceleration = 0
        
        contents = image
    }
}
