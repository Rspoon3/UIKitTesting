//
//  OfferReactionSnackBarView.swift
//  UIKitTesting
//
//  Created by Richard Witherspoon on 1/26/24.
//

import UIKit

/// A view to be used by `OfferReactionSnackbarManager` that shows the users liked offers in a snackbar view
final class OfferReactionSnackBarView: UIView {
    private let likeCountLabel = UILabel()
    private var gradientLayer: CAGradientLayer?

    var likeCount: Int {
        didSet {
            updateLike(count: likeCount)
        }
    }
    
    // MARK: - Initializer
    
    init(likeCount: Int) {
        self.likeCount = likeCount
        super.init(frame: .zero)
        setupViews()
        
//        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
//        addGestureRecognizer(tap)
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongPress(_:)))
        longPress.minimumPressDuration = 0
        addGestureRecognizer(longPress)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        likeCount += 1
    }
    
    
    @objc func handleLongPress(_ sender: UILongPressGestureRecognizer? = nil) {
        
        guard let sender else { return }
        
        if sender.state == .began {
            alpha = 0.75
            UIView.animate(withDuration: 0.1) {
                self.transform = .init(scaleX: 0.95, y: 0.95)
            }
        } else if sender.state == .ended {
            alpha = 1
            UIView.animate(withDuration: 0.1) {
                self.transform = .init(scaleX: 1, y: 1)
            }
            likeCount += 1
        }
    }
    
    required init?(coder: NSCoder) {
        return nil
    }
    
    // MARK: - LifeCyle
//    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        super.touchesBegan(touches, with: event)
//        likeCount += 1
//    }
//    
    override func layoutSubviews() {
        super.layoutSubviews()
        let boarderWidth: CGFloat = 6
        let cornerRadius = bounds.height / 2
        let colors = [
            UIColor(red: 236/255, green: 72/255, blue: 153/255, alpha: 1),
            UIColor(red: 189/255, green: 50/255, blue: 211/255, alpha: 1)
        ]
        
        gradientLayer?.removeFromSuperlayer()
        gradientLayer = CAGradientLayer()
        guard let gradientLayer else { return }
        
        gradientLayer.frame = CGRect(origin: .zero, size: bounds.size)
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradientLayer.colors = colors.map(\.cgColor)
        gradientLayer.cornerRadius = cornerRadius
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.lineWidth = boarderWidth
        shapeLayer.path = UIBezierPath(rect: bounds).cgPath
        
        shapeLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
        shapeLayer.fillColor = nil
        shapeLayer.strokeColor = UIColor.black.cgColor
        
        gradientLayer.mask = shapeLayer
        
        layer.addSublayer(gradientLayer)
        layer.cornerRadius = cornerRadius
//        layer.applyFigmaShadow(
//            alpha: 0.15,
//            x: 0,
//            y: 5,
//            blur: 12,
//            spread: 0
//        )
    }
    
    // MARK: - Helpers
    
    private func updateLike(count: Int) {
        UIView.transition(
            with: self,
            duration: 1/3,
            options: .transitionCrossDissolve
        ) { [weak self] in
            self?.likeCountLabel.text = count.formatted()
        }
    }
    
    private func setupViews() {
        // TODO: Use 'reaction.liked.v2' once FRA-20898 is merged.
        let image = UIImage(systemName: "heart.fill")
        let imageView = UIImageView(image: image)
        let stackView = UIStackView(arrangedSubviews: [imageView, likeCountLabel])
        let heightAndWidth: CGFloat = 20
        let verticalPadding: CGFloat = 12
        let horizontalPadding: CGFloat = 20
        
        likeCountLabel.accessibilityIdentifier = "offer_reaction_like_count"
        imageView.accessibilityIdentifier = "offer_reaction_heart"
        imageView.tintColor = .systemRed
        imageView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 6
        
//        likeCountLabel.font
        likeCountLabel.text = likeCount.formatted()
        backgroundColor = UIColor(red: 1, green: 232/255, blue: 247/255, alpha: 1)
        
        addSubview(stackView)
        
        if !UIAccessibility.isReduceMotionEnabled {
            let scale = 1.075
            UIView.animate(
                withDuration: 0.5,
                delay: 0,
                options: [.repeat, .autoreverse]
            ) {
                imageView.transform = CGAffineTransform(scaleX: scale, y: scale)
            }
        }
            
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: heightAndWidth),
            imageView.heightAnchor.constraint(equalToConstant: heightAndWidth),
            
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: verticalPadding),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -verticalPadding),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: horizontalPadding),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -horizontalPadding)
        ])
    }
}

#Preview {
    OfferReactionSnackBarView(likeCount: 12)
}
