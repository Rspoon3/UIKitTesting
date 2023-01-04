//
//  CarouselCell.swift
//  UIKitTesting
//
//  Created by Richard Witherspoon on 12/9/22.
//

import UIKit


final class CarouselCell: UICollectionViewCell {
    private let imageView = UIImageView()
    private let reflectedImageView = UIImageView()
    private let cornerRadius: CGFloat = 8
    private let context = CIContext()
    private let filter = CIFilter(name: "CIGaussianBlur")!
    private let blurRadius = 24
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        if let attribute = layoutAttributes as? CarouselLayoutAttributes {
            reflectionOpacity(percentage: attribute.percentageToMidX)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = cornerRadius
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
//        imageView.alpha = 0.1
        
        reflectedImageView.layer.cornerRadius = cornerRadius
//        reflectedImageView.contentMode = .scaleAspectFill
//        reflectedImageView.contentMode = .scaleToFill //default
        reflectedImageView.translatesAutoresizingMaskIntoConstraints = false
//        reflectedImageView.layer.borderColor = UIColor.black.cgColor
//        reflectedImageView.layer.borderWidth = 1
        
        
//        let blurEffect = UIBlurEffect(style: .systemThinMaterial)
//        let blurEffectView = UIVisualEffectView(effect: blurEffect)
//        blurEffectView.frame = contentView.bounds
//        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        contentView.addSubview(reflectedImageView)

//        contentView.addSubview(blurEffectView)
        
        contentView.addSubview(imageView)
        
        let blurPadding:CGFloat = CGFloat(blurRadius) / 2
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.heightAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.5),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            reflectedImageView.topAnchor.constraint(equalTo: imageView.topAnchor, constant: 36 - blurPadding),
            reflectedImageView.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 4 + blurPadding * 2),
            reflectedImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20 - blurPadding),
            reflectedImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20 + blurPadding)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createBluredImage(using image: UIImage, p: CGFloat = 24) -> UIImage? {
        let beginImage = CIImage(image: image)
        
        filter.setValue(beginImage, forKey: kCIInputImageKey)
        filter.setValue(p, forKey: kCIInputRadiusKey)
        
        guard
            let outputImage = filter.outputImage,
            let cgImage = context.createCGImage(outputImage, from: outputImage.extent)
        else {
            return nil
        }
        
        return UIImage(cgImage: cgImage)
    }
    
    
    func configure(with imageTitle: String, indexPath: IndexPath) {
        guard let image = UIImage(named: imageTitle) else { return }
        
        imageView.image = image
        reflectedImageView.image = createBluredImage(using: image)
    }
    
    func reflectionOpacity(percentage: Double) {
        reflectedImageView.alpha = percentage * 0.6
    }
}
