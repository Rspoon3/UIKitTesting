//
//  ViewController.swift
//  UIKitTesting
//
//  Created by Richard Witherspoon on 3/1/22.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
//        CelebrationConfetti.performConfetti(on: view)
        CelebrationView.present(on: view)
    }
}

final class CelebrationConfetti {

    static func performConfetti(on view: UIView) {
        view.addSubview(View(type: .confetti))
    }
}


extension CelebrationConfetti {
    class View: UIView {

        var builder: Builder
        var type: Kind
        var useBackgroundLayer: Bool

        convenience init(type: Kind = .confetti, useBackgroundLayer: Bool = true) {
            self.init(type: .confetti, builder: Builder(), useBackgroundLayer: useBackgroundLayer)
        }

        required init(type: Kind, builder: Builder, useBackgroundLayer: Bool) {
            self.type = type
            self.builder = builder
            self.useBackgroundLayer = useBackgroundLayer

            super.init(frame: .zero)
            isUserInteractionEnabled = false
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        override func didMoveToSuperview() {
            super.didMoveToSuperview()

            guard let superviewFrame = superview?.frame else { return }

            frame = superviewFrame

            let confettiLayerArray = useBackgroundLayer ?
            [foregroundConfettiLayer, backgroundConfettiLayer] :
            [foregroundConfettiLayer]

            for layer in confettiLayerArray {
                self.layer.addSublayer(layer)
                addBehaviors(to: layer)
                addAnimations(to: layer)
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                self.removeFromSuperview()
            }
        }

        func addBehaviors(to layer: CAEmitterLayer) {
            layer.setValue([
                Behavior.horizontalWave.instantiate(),
                Behavior.verticalWave.instantiate(),
                Behavior.attractor.instantiate(layer: layer)
            ], forKey: "emitterBehaviors")
        }

        func addAnimations(to layer: CAEmitterLayer) {
            Animation.attractor.add(to: layer)
            Animation.birthrate.add(to: layer)
            Animation.gravity.add(to: layer, confettiTypes: builder.confettiTypes)
        }

        lazy var foregroundConfettiLayer = {
            builder.createConfettiLayer(bounds: bounds)
        }()

        lazy var backgroundConfettiLayer: CAEmitterLayer = {
            let emitterLayer = builder.createConfettiLayer(bounds: bounds)

            for emitterCell in emitterLayer.emitterCells ?? [] {
                emitterCell.scale = 0.5
            }

            emitterLayer.opacity = 0.5
            emitterLayer.speed = 0.95

            return emitterLayer
        }()
    }
}


extension CelebrationConfetti {
    enum Kind: String {
        case confetti
    }
}



extension CelebrationConfetti.View {
    class Builder {

        var cellBirthrate: Float { 100 }

        func createConfettiCells() -> [CAEmitterCell] {
            return confettiTypes.map { confettiType in
                let cell = CAEmitterCell()
                cell.name = confettiType.name

                cell.beginTime = 0.1
                cell.birthRate = self.cellBirthrate
                cell.contents = confettiType.image.cgImage
                cell.emissionRange = CGFloat(Double.pi)
                cell.lifetime = 10
                cell.spin = 4
                cell.spinRange = 8
                cell.velocityRange = 0
                cell.yAcceleration = 0

                cell.setValue("plane", forKey: "particleType")
                cell.setValue(Double.pi, forKey: "orientationRange")
                cell.setValue(Double.pi / 2, forKey: "orientationLongitude")
                cell.setValue(Double.pi / 2, forKey: "orientationLatitude")

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
            createConfettiTypes()
        }()

        func createConfettiTypes() -> [ConfettiType] {
            // For each position x shape x color, construct an image
            confettiPositions.flatMap { position in
                self.confettiShapes.flatMap { shape in
                    self.confettiColors.map { color in
                        ConfettiType(color: color, shape: shape, position: position)
                    }
                }
            }
        }

        var confettiColors: [UIColor] {
            [
                (r: 149, g: 58, b: 255), (r: 255, g: 195, b: 41), (r: 255, g: 101, b: 26),
                (r: 123, g: 92, b: 255), (r: 76, g: 126, b: 255), (r: 71, g: 192, b: 255),
                (r: 255, g: 47, b: 39), (r: 255, g: 91, b: 134), (r: 233, g: 122, b: 208)
            ].map { UIColor(red: $0.r / 255.0, green: $0.g / 255.0, blue: $0.b / 255.0, alpha: 1) }
        }

        var confettiPositions: [ConfettiType.Position] {
            [ConfettiType.Position.foreground, ConfettiType.Position.background]
        }

        var confettiShapes: [ConfettiType.Shape] {
            [ConfettiType.Shape.rectangle, ConfettiType.Shape.circle]
        }
    }
}


extension CelebrationConfetti.View {
    enum Behavior {
        case horizontalWave
        case verticalWave
        case attractor
        case drag

        func instantiate(layer: CAEmitterLayer? = nil) -> Any {
            [
                Behavior.horizontalWave: { self.horizontalWaveBehavior() },
                Behavior.verticalWave: { self.verticalWaveBehavior() },
                Behavior.attractor: { self.attractorBehavior(for: layer!) },
                Behavior.drag: { self.dragBehavior() }
            ][self, default: { NSObject() }]()
        }

        private func horizontalWaveBehavior() -> Any {
            let behavior = createBehavior(type: "wave")
            behavior.setValue([100, 0, 0], forKeyPath: "force")
            behavior.setValue(0.5, forKeyPath: "frequency")
            return behavior
        }

        private func verticalWaveBehavior() -> Any {
            let behavior = createBehavior(type: "wave")
            behavior.setValue([0, 500, 0], forKeyPath: "force")
            behavior.setValue(3, forKeyPath: "frequency")
            return behavior
        }

        private func attractorBehavior(for emitterLayer: CAEmitterLayer) -> Any {
            let behavior = createBehavior(type: "attractor")
            behavior.setValue("attractor", forKeyPath: "name")

            // Attractiveness
            behavior.setValue(-290, forKeyPath: "falloff")
            behavior.setValue(300, forKeyPath: "radius")
            behavior.setValue(10, forKeyPath: "stiffness")

            // Position
            behavior.setValue(CGPoint(x: emitterLayer.emitterPosition.x,
                                      y: emitterLayer.emitterPosition.y + 20),
                              forKeyPath: "position")
            behavior.setValue(-70, forKeyPath: "zPosition")

            return behavior
        }

        private func dragBehavior() -> Any {
            let behavior = createBehavior(type: "drag")
            behavior.setValue("drag", forKey: "name")
            behavior.setValue(2, forKey: "drag")

            return behavior
        }

        private func createBehavior(type: String) -> NSObject {
            // swiftlint:disable:next force_cast
            let behaviorClass = NSClassFromString("CAEmitterBehavior") as! NSObject.Type
            let behaviorWithType = behaviorClass.method(for: NSSelectorFromString("behaviorWithType:"))!
            let castedBehaviorWithType = unsafeBitCast(behaviorWithType, to: (@convention(c)(Any?, Selector, Any?) -> NSObject).self)
            return castedBehaviorWithType(behaviorClass, NSSelectorFromString("behaviorWithType:"), type)
        }
    }
}


extension CelebrationConfetti.View {
    enum Animation {
        case attractor
        case birthrate
        case drag
        case gravity

        func add(to layer: CALayer, confettiTypes: [ConfettiType]? = nil) {
            [
                Animation.attractor: { self.addAttractorAnimation(to: layer) },
                Animation.birthrate: { self.addBirthrateAnimation(to: layer) },
                Animation.drag: { self.addDragAnimation(to: layer) },
                Animation.gravity: {
                    guard confettiTypes != nil else { fatalError("confettiTypes:[ConfettiType] must be provided") }
                    self.addGravityAnimation(to: layer, confettiTypes: confettiTypes!) }
            ][self, default: {}]()
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

        private func addDragAnimation(to layer: CALayer) {
            let animation = CABasicAnimation()
            animation.duration = 0.35
            animation.fromValue = 0
            animation.toValue = 2

            layer.add(animation, forKey: "emitterBehaviors.drag.drag")
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
    }
}

extension CelebrationConfetti.View {
    class ConfettiType {
        let color: UIColor
        let shape: Shape
        let position: Position

        init(color: UIColor? = nil, shape: Shape? = nil, position: Position, image: UIImage? = nil) {
            self.color = color ?? .clear
            self.shape = shape ?? .unspecified
            self.position = position
            self.image = image ?? self.image
        }

        lazy var name = UUID().uuidString

        lazy var image: UIImage = {
            let imageRect: CGRect = shape.rect()

            UIGraphicsBeginImageContext(imageRect.size)
            let context = UIGraphicsGetCurrentContext()!
            context.setFillColor(color.cgColor)

            shape.fill(context: context)

            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return image!
        }()

        enum Shape {
            case rectangle
            case circle
            case unspecified

            func rect() -> CGRect {
                [
                    Shape.rectangle: { CGRect(x: 0, y: 0, width: 20, height: 13) },
                    Shape.circle: { CGRect(x: 0, y: 0, width: 10, height: 10) }
                ][self, default: { .zero }]()
            }

            func fill(context: CGContext) {
                [
                    Shape.rectangle: { context.fill(self.rect()) },
                    Shape.circle: { context.fillEllipse(in: self.rect()) }
                ][self, default: {}]()
            }
        }

        enum Position {
            case foreground
            case background
        }
    }
}


enum ConfettiType: String {
    case confetti = "confetti"
    case fireworks = "fireworks"
    case fade_zoom = "zoomfade"
}

public class CelebrationView: UIView {
    static let defaultParticleImages = ["Confetti-Particle_01",
                          "Confetti-Particle_02",
                          "Confetti-Particle_03",
                          "Confetti-Particle_04",
                          "Confetti-Particle_05",
                          "Confetti-Particle_06",
                          "Confetti-Particle_07"]

    // MARK: - Initializer
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.isUserInteractionEnabled = false
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.isUserInteractionEnabled = false
    }
    
    // MARK: - Public
    
    @discardableResult static func present(on view: UIView, belowView: UIView? = nil, imagesJson: String? = nil, timeLength: TimeInterval = 4.0, overrideScale: Float = 1.0) -> CelebrationView {
        let celebView = CelebrationView(frame: view.bounds)
        if let belowView {
            view.insertSubview(celebView, belowSubview: belowView)
        } else {
            view.addSubview(celebView)
        }

        celebView.start(sType: "confetti", birthrate: 15, sImages: defaultParticleImages, sImageJson: imagesJson, timeLength: timeLength, overrideScale: overrideScale) {
            celebView.removeFromSuperview()
        }

        return celebView
    }


    // MARK: - Private
    
    private func loadImageJson(imageJson: String?) -> [CGImage] {
        // get our images
        var imageURLs: [String] = []

        if let jsonStr = imageJson {
            let data = Data(jsonStr.utf8)
            do {
                let jsonResponse = try JSONSerialization.jsonObject(with: data, options: [])
                imageURLs = (jsonResponse as? [String])!
            } catch {
            }
        }

        // now load the images
        var images: [CGImage] = []

        for imageName in imageURLs {
            if let url = URL(string: imageName) {
                if let data = try? Data(contentsOf: url) {
                    if let cg = UIImage(data: data)?.cgImage {
                        images.append(cg)
                    }
                }
            }
        }

        return images
    }

    private func loadImages(images: [String]?) -> [CGImage] {
        guard let images else { return [] }

        // load the images
        var cgImages: [CGImage] = []
 
        for imageName in images {
            if let cg = UIImage(named: imageName)?.cgImage {
                cgImages.append(cg)
            }
        }
            
        return cgImages
    }
    
    private func loadColors(colorJson: String?) -> [CGColor] {
        var colorStrings: [String] = []
   
        if let colorJson {

            let data = Data(colorJson.utf8)
            do {
                let jsonResponse = try JSONSerialization.jsonObject(with: data, options: [])
                colorStrings = (jsonResponse as? [String])!
            } catch {
            }
        }
        
        // now load the colors
        var colors: [CGColor] = []
        
        for colorHex in colorStrings {
//            if let cgc: CGColor = UIColor.color(hexString: colorHex)?.cgColor {
//                colors.append(cgc)
//            }
        }
        
        return colors
    }
    
    private func emitterCell(type: ConfettiType, birthrate: Float, color: CGColor?, image: CGImage?, overrideScale: Float) -> CAEmitterCell {
        let cell = CAEmitterCell()

        switch type {
        case .fireworks:
            cell.birthRate = birthrate
            cell.beginTime = CACurrentMediaTime()
            cell.lifetime = 5
            cell.velocity = 250
            cell.velocityRange = 10
            cell.emissionLongitude = CGFloat(-Double.pi*0.5)
            cell.emissionRange = CGFloat(Double.pi * 0.35)
            cell.spinRange = 10
            cell.scaleRange = 0.1
            cell.alphaSpeed = -0.2
            cell.yAcceleration = 300
            cell.scale = 0.25
            cell.scaleSpeed = 0.2

        case .confetti:
            cell.birthRate = birthrate
            cell.beginTime = CACurrentMediaTime() + Double.random(in: 0.0 ..< 1)
            cell.lifetime = 15
            cell.velocity = 200
            cell.velocityRange = 20
            cell.emissionLongitude = CGFloat(Double.pi)
            cell.scale = CGFloat(overrideScale)
            cell.spinRange = 20
            cell.yAcceleration = 0

        case .fade_zoom:
            cell.birthRate = birthrate
            cell.lifetime = 3
            cell.velocity = 75
            cell.velocityRange = 0
            cell.emissionRange = CGFloat(Double.pi * 2)
            cell.spin = 3
            cell.spinRange = 5
            cell.scale = 0.1
            cell.scaleSpeed = 0.25
            cell.alphaSpeed = -0.4
        }
        
        if color != nil {
            cell.color = color
        }
        cell.contents = image
        
        return cell
    }

    private func start() {
        start(sType: "confetti", birthrate: 15, sImages: CelebrationView.defaultParticleImages, sImageJson: nil, timeLength: 4.0, overrideScale: 1.0) {
                self.removeFromSuperview()
        }
    }

    private func start(
        sType: String,
        birthrate: Float,
        sImages: [String]? = nil,
        sImageJson: String? = nil,
        sColors: String? = nil,
        timeLength: TimeInterval,
        overrideScale: Float,
        completion: @escaping () -> Void
    ) {
        let layer = CAEmitterLayer()

        let type = ConfettiType(rawValue: sType)
        var images = (sImages != nil) ? loadImages(images: sImages ) : loadImageJson(imageJson: sImageJson)
        let colors = loadColors(colorJson: sColors)

        let useColors = images.isEmpty
        if useColors {
            // put in default images
            if let cg = UIImage(named: "confetti_square")?.cgImage {
               images.append(cg)
            }
            if let cg = UIImage(named: "confetti_circle")?.cgImage {
               images.append(cg)
            }
            if let cg = UIImage(named: "confetti_tri")?.cgImage {
               images.append(cg)
            }
        }
        
        switch type {
        case .fireworks:
            layer.emitterPosition = CGPoint(x: self.bounds.size.width*0.5, y: self.bounds.size.height*0.1)
            layer.emitterShape = CAEmitterLayerEmitterShape.point
            layer.emitterSize = CGSize(width: 1, height: 1)
            layer.renderMode = CAEmitterLayerRenderMode.backToFront

        case .fade_zoom:
            layer.emitterPosition = CGPoint(x: self.bounds.size.width*0.5, y: self.bounds.size.height*0.5)
            layer.emitterShape = CAEmitterLayerEmitterShape.rectangle
            layer.emitterSize = CGSize(width: self.bounds.size.width*0.5, height: self.bounds.size.height*0.8)
            layer.renderMode = CAEmitterLayerRenderMode.backToFront

        case .confetti:
            fallthrough

        default:
            layer.emitterPosition = CGPoint(x: self.bounds.size.width*0.5, y: -self.bounds.size.height*0.25)
            layer.emitterShape = CAEmitterLayerEmitterShape.line
            layer.emitterSize = CGSize(width: self.bounds.size.width, height: self.bounds.size.height*0.2)
            layer.renderMode = CAEmitterLayerRenderMode.backToFront
        }
    
        // create our emitters
        var cells = [CAEmitterCell]()
            
        if useColors {
            // random colors & images
            for image in images {
                for color in colors {
                    let cell = emitterCell(type: type ?? .confetti,
                                           birthrate: birthrate/Float(colors.count),
                                            color: color,
                                            image: image,
                                            overrideScale: overrideScale)
                    cells.append(cell)
                }
            }
        } else {
            // animate random images
            for image in images {
                let cell = emitterCell(type: type ?? .confetti,
                                        birthrate: birthrate / Float(images.count),
                                        color: colors.first,
                                        image: image,
                                        overrideScale: overrideScale)
                cells.append(cell)
            }
        }
         
        layer.emitterCells = cells
        self.layer.addSublayer(layer)

        // light haptic feedback
//        HapticsManager.shared.addFeedback(.impact(.medium), named: .celebrationView)
//        HapticsManager.shared.prepareFeedback(named: .celebrationView)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
            let feedbackTimer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { (_) in
//                HapticsManager.shared.generateFeedback(.impact(), named: .celebrationView)
//                HapticsManager.shared.removeFeedback(named: .celebrationView)
            }
            // stop after a bit
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                feedbackTimer.invalidate()
            }
        }

        // stop after a while
        let timeDelay: TimeInterval = timeLength==0 ? 2.0 : timeLength
        
        DispatchQueue.main.asyncAfter(deadline: .now() + timeDelay) {
            layer.birthRate = 0
            DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
                layer.removeFromSuperlayer()
                completion()
            }
        }
    }
}
