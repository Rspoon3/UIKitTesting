//
//  CarouselCell.swift
//  UIKitTesting
//
//  Created by Richard Witherspoon on 12/9/22.
//

import UIKit
import FLAnimatedImage

struct CellInfo {
    let index: Int
    let showGif: Bool
    let cellType: CarouselVC.CellType?
    let imageTitle: String
}

final class CarouselCell: UICollectionViewCell {
    private let imageView = FLAnimatedImageView()
    private let reflectedImageView = UIImageView()
    private let cornerRadius: CGFloat = 8
    private let context = CIContext()
    private let filter = CIFilter(name: "CIGaussianBlur")!
    private let blurRadius = 24
    private let typeLabel = UILabel()
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        if let attribute = layoutAttributes as? CarouselLayoutAttributes {
            reflectionOpacity(percentage: attribute.percentageToMidX)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        typeLabel.translatesAutoresizingMaskIntoConstraints = false
        typeLabel.alpha = 0
        
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
        
        
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = contentView.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        contentView.addSubview(reflectedImageView)

        contentView.addSubview(blurEffectView)
        
        contentView.addSubview(imageView)
        
        contentView.addSubview(typeLabel)
        
        let blurPadding:CGFloat = CGFloat(blurRadius) / 2
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.heightAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.5),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            reflectedImageView.topAnchor.constraint(equalTo: imageView.topAnchor, constant: 36 - blurPadding),
            reflectedImageView.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 4 + blurPadding * 2),
            reflectedImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20 - blurPadding),
            reflectedImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20 + blurPadding),
            
            typeLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            typeLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
        
//        print("CELL: \(contentView.frame.width) \(contentView.bounds.width)")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createBluredImage(using image: UIImage) -> UIImage? {
        let width = contentView.frame.width - 40
        let height = contentView.frame.height - 36 + 4
        
        guard let resized = resizeImage(with: image, scaledToFill: .init(width: width, height: height)) else {
            return nil
        }
        
        let beginImage = CIImage(image: resized)
        
        filter.setValue(beginImage, forKey: kCIInputImageKey)
        filter.setValue(blurRadius, forKey: kCIInputRadiusKey)
        
        guard
            let outputImage = filter.outputImage,
            let cgImage = context.createCGImage(outputImage, from: outputImage.extent)
        else {
            return nil
        }
        
        let i = UIImage(cgImage: cgImage)
        return i
    }
    
    
    func configure(info: CellInfo) {
        guard let image = UIImage(named: info.imageTitle) else { return }

        let gifData = try! Data(contentsOf: Bundle.main.url(forResource: "slideGif", withExtension: "gif")!)
        let gif = FLAnimatedImage(gifData: gifData)
        
        if info.index.isMultiple(of: 4) && info.showGif {
            imageView.animatedImage = gif
            reflectedImageView.image = createBluredImage(using: imageView.image!)
        } else {
            imageView.image = image
            reflectedImageView.image = createBluredImage(using: image)
        }
        
        if let text = info.cellType?.rawValue {
            typeLabel.text = text
            typeLabel.alpha = 1
        } else {
            typeLabel.alpha = 0
        }
    }
    
    func reflectionOpacity(percentage: Double) {
        reflectedImageView.alpha = percentage * 0.6
    }
    
    private func resizeImage(with image: UIImage?, scaledToFill size: CGSize) -> UIImage? {
        let scale: CGFloat = max(size.width / (image?.size.width ?? 0.0), size.height / (image?.size.height ?? 0.0))
        let width: CGFloat = (image?.size.width ?? 0.0) * scale
        let height: CGFloat = (image?.size.height ?? 0.0) * scale
        let imageRect = CGRect(x: (size.width - width) / 2.0, y: (size.height - height) / 2.0, width: width, height: height)
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        image?.draw(in: imageRect)
        
        let newImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}
