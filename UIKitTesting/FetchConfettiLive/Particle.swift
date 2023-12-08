//
//  ConfettiType.swift
//
//
//  Created by Richard Witherspoon on 11/2/23.
//

import UIKit

/// A type that describes the confetti particle
final class Particle {
    let color: UIColor
    let shape: Shape
    let position: Position
    let id = UUID().uuidString
    let image: UIImage
    
    init(
        color: UIColor,
        shape: Shape,
        position: Position
    ) {
        self.color = color
        self.shape = shape
        self.position = position
        
        // Create UIImage
        let renderer = UIGraphicsImageRenderer(size: shape.rect.size)
        let img = renderer.image { context in
            let cgContext = context.cgContext
            
            cgContext.setFillColor(color.cgColor)
            
            switch shape {
            case .rectangle:
                cgContext.fill(shape.rect)
            case .circle:
                cgContext.fillEllipse(in: shape.rect)
            }
        }
        
        image = img
    }
    
    enum Shape {
        case rectangle
        case circle
        
        var rect: CGRect {
            switch self {
            case .rectangle:
                CGRect(x: 0, y: 0, width: 6.5, height: 4)
            case .circle:
                CGRect(x: 0, y: 0, width: 4, height: 4)
            }
        }
    }
    
    enum Position: CaseIterable {
        case foreground
        case background
    }
}
