//
//  CelebrationRainView.swift
//
//
//  Created by Richard Witherspoon on 11/2/23.
//

import UIKit

@MainActor
public final class CelebrationRainView: UIView {
    private let hapticsManager: any HapticsEngineManaging
    
    // MARK: - Initializer
    
    required public init?(coder aDecoder: NSCoder) {
        nil
    }
    
    public init(
        hapticsManager: any HapticsEngineManaging
    ) {
        self.hapticsManager = hapticsManager
        super.init(frame: .zero)
        self.isUserInteractionEnabled = false
    }
    
    // MARK: - Public
    
    @MainActor
    func present(
        on view: UIView,
        belowView: UIView? = nil,
        duration: TimeInterval = 4.0
    ) async throws {
        frame = view.bounds
        
        if let belowView {
            view.insertSubview(self, belowSubview: belowView)
        } else {
            view.addSubview(self)
        }
        
        try await start(
            birthrate: 15,
            duration: duration
        )
        
        removeFromSuperview()
    }
    
    // MARK: - Private
    
    private func start(
        birthrate: Float,
        duration: TimeInterval
    ) async throws {
        let layer = CAEmitterLayer()
        let defaultParticleImageNames = Array(1...7).map {
            "confettiParticle\($0)"
        }
        let images =  defaultParticleImageNames.compactMap {
            UIImage(named: $0)?.cgImage
        }
        
        layer.emitterPosition = CGPoint(x: bounds.size.width * 0.5, y: -bounds.size.height * 0.25)
        layer.emitterShape = CAEmitterLayerEmitterShape.line
        layer.emitterSize = CGSize(width: bounds.size.width, height: bounds.size.height*0.2)
        layer.renderMode = CAEmitterLayerRenderMode.backToFront
        
        // create our emitters
        let cells: [CAEmitterCell] = images.map { image in
            CAEmitterCell(
                birthrate: birthrate / Float(images.count),
                image: image
            )
        }
        
        layer.emitterCells = cells
        self.layer.addSublayer(layer)
        
        fireOffHaptics()
        
        // stop after a while
        let timeDelay: TimeInterval = max(2.0, duration)
        
        try await Task.sleep(for: .seconds(1 * timeDelay))
        layer.birthRate = 0
        try await Task.sleep(for: .seconds(3))
        
        await UIView.animate(withDuration: 1) {
            self.alpha = 0
        }
        
        layer.removeFromSuperlayer()
    }
    
    private func fireOffHaptics() {
        hapticsManager.addFeedback(.impact(.medium), named: .celebrationView)
        hapticsManager.prepareFeedback(named: .celebrationView)
        
        Task {
            try await Task.sleep(for: .milliseconds(750))
            
            let feedbackTimer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { [weak self] _ in
                self?.hapticsManager.generateFeedback(.impact(), named: .celebrationView)
                self?.hapticsManager.removeFeedback(named: .celebrationView)
            }
            
            // stop after a bit
            try await Task.sleep(for: .milliseconds(2500))
            feedbackTimer.invalidate()
        }
    }
}
