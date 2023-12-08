//
//  ConfettiType.swift
//
//
//  Created by Richard Witherspoon on 11/2/23.
//

import UIKit

final class ConfettiType {
    let color: UIColor
    let shape: Shape
    let position: Position

    init(
        color: UIColor? = nil,
        shape: Shape? = nil,
        position: Position,
        image: UIImage? = nil
    ) {
        self.color = color ?? .clear
        self.shape = shape ?? .unspecified
        self.position = position
        self.image = image ?? self.image
    }

    lazy var name = UUID().uuidString

    lazy var image: UIImage? = {
        let imageRect: CGRect = shape.rect

        UIGraphicsBeginImageContext(imageRect.size)
        
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        
        context.setFillColor(color.cgColor)

        shape.fill(context: context)

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }()

    enum Shape {
        case rectangle
        case circle
        case unspecified
        
        var rect: CGRect {
            switch self {
            case .rectangle:
                CGRect(x: 0, y: 0, width: 20, height: 13)
            case .circle:
                CGRect(x: 0, y: 0, width: 10, height: 10)
            case .unspecified:
                    .zero
            }
        }

        func fill(context: CGContext) {
            if self == .rectangle {
                context.fill(rect)
            } else if self == .circle {
                context.fillEllipse(in: rect)
            }
        }
    }

    enum Position: CaseIterable {
        case foreground
        case background
    }
}
