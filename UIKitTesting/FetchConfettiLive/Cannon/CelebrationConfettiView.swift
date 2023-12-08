//
//  CelebrationConfettiView.swift
//
//
//  Created by Richard Witherspoon on 11/2/23.
//

import UIKit

/// A view which displays a confetti celebration.
public final class CelebrationConfettiView: UIView {
    private let builder = Builder()
    
    // MARK: - Initializer
    
    required init() {
        super.init(frame: .zero)
        isUserInteractionEnabled = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public
    
    func present(on view: UIView) async throws {
        frame = view.bounds
        view.addSubview(self)
        
        let confettiLayerArray = [foregroundConfettiLayer(), backgroundConfettiLayer()]
        
        for layer in confettiLayerArray {
            self.layer.addSublayer(layer)
            addBehaviors(to: layer)
            addAnimations(to: layer)
        }
        
        try await Task.sleep(for: .seconds(5))
            
        removeFromSuperview()
    }
    
    // MARK: - Private Helpers
    
    private func addBehaviors(to layer: CAEmitterLayer) {
        layer.setValue(
            [
                horizontalWaveBehavior(),
                verticalWaveBehavior(),
                attractorBehavior(for: layer)
            ],
            forKey: "emitterBehaviors"
        )
    }
    
    private func addAnimations(to layer: CAEmitterLayer) {
        addAttractorAnimation(to: layer)
        addBirthrateAnimation(to: layer)
        addGravityAnimation(
            to: layer,
            confettiTypes: builder.confettiTypes
        )
    }

    private func addAttractorAnimation(to layer: CALayer) {
        let animation = CAKeyframeAnimation()
        animation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        animation.duration = 3
        animation.keyTimes = [0, 0.4]
        animation.values = [80, 5]

        layer.add(animation, forKey: "emitterBehaviors.attractor.stiffness")
    }

    private func addBirthrateAnimation(to layer: CALayer) {
        let animation = CABasicAnimation()
        animation.duration = 1
        animation.fromValue = 1
        animation.toValue = 0

        layer.add(animation, forKey: "birthRate")
    }

    private func addGravityAnimation(to layer: CALayer, confettiTypes: [ConfettiType]) {
        let animation = CAKeyframeAnimation()
        animation.duration = 6
        animation.keyTimes = [0.05, 0.1, 0.5, 1]
        animation.values = [0, 100, 2000, 4000]

        for image in confettiTypes {
            layer.add(animation, forKey: "emitterCells.\(image.name).yAcceleration")
        }
    }
    
    private func horizontalWaveBehavior() -> Any? {
        let behavior = createBehavior(type: "wave")
        behavior?.setValue([100, 0, 0], forKeyPath: "force")
        behavior?.setValue(0.5, forKeyPath: "frequency")
        return behavior
    }

    private func verticalWaveBehavior() -> Any? {
        let behavior = createBehavior(type: "wave")
        behavior?.setValue([0, 500, 0], forKeyPath: "force")
        behavior?.setValue(3, forKeyPath: "frequency")
        return behavior
    }

    private func attractorBehavior(for emitterLayer: CAEmitterLayer) -> Any? {
        let behavior = createBehavior(type: "attractor")
        behavior?.setValue("attractor", forKeyPath: "name")

        // Attractiveness
        behavior?.setValue(-290, forKeyPath: "falloff")
        behavior?.setValue(300, forKeyPath: "radius")
        behavior?.setValue(10, forKeyPath: "stiffness")

        // Position
        behavior?.setValue(
            CGPoint(
                x: emitterLayer.emitterPosition.x,
                y: emitterLayer.emitterPosition.y + 20
            ),
            forKeyPath: "position"
        )
        behavior?.setValue(-70, forKeyPath: "zPosition")

        return behavior
    }

    private func createBehavior(type: String) -> NSObject? {
        guard let behaviorClass = NSClassFromString("CAEmitterBehavior") as? NSObject.Type else {
            return nil
        }
        
        let behaviorWithType = behaviorClass.method(for: NSSelectorFromString("behaviorWithType:"))
        let castedBehaviorWithType = unsafeBitCast(behaviorWithType, to: (@convention(c)(Any?, Selector, Any?) -> NSObject).self)
        return castedBehaviorWithType(behaviorClass, NSSelectorFromString("behaviorWithType:"), type)
    }
    
    private func foregroundConfettiLayer () -> CAEmitterLayer {
        builder.createConfettiLayer(bounds: bounds)
    }
    
    private func backgroundConfettiLayer() -> CAEmitterLayer {
        let emitterLayer = builder.createConfettiLayer(bounds: bounds)
        
        for emitterCell in emitterLayer.emitterCells ?? [] {
            emitterCell.scale = 0.5
        }
        
        emitterLayer.opacity = 0.5
        emitterLayer.speed = 0.95
        
        return emitterLayer
    }
}
