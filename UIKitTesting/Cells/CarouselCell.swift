//
//  CarouselCell.swift
//  UIKitTesting
//
//  Created by Richard Witherspoon on 12/9/22.
//

import SwiftUI
import FLAnimatedImage


struct GIFView: UIViewRepresentable {
    let data: Data
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)
        let gif = FLAnimatedImage(gifData: data)!
        let imageView = FLAnimatedImageView()
        
        imageView.animatedImage = gif
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalTo: view.heightAnchor),
            imageView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])

        return view
      }
    
    func updateUIView(_ uiView: UIView, context: Context) {
    }
}

struct CarouselCellView: View {
    private let cornerRadius: CGFloat = 8
    let title: String
    let indexPath: Int
    let gifData = try! Data(contentsOf: Bundle.main.url(forResource: "slideGif", withExtension: "gif")!)
    private let testOpactiy: Double = 1
    
    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .top) {
                if indexPath.isMultiple(of: 4) {
                    GIFView(data: gifData)
                        .cornerRadius(cornerRadius)
                        .padding(.top, 36)
                        .padding(.horizontal, 40)
                        .blur(radius: 20)
                    
                    GIFView(data: gifData)
                        .cornerRadius(cornerRadius)
                        .padding(.bottom, 4)
                        .opacity(testOpactiy)
                } else {
                    Image(title)
                        .resizable()
                        .cornerRadius(cornerRadius)
                        .padding(.top, 36)
                        .padding(.horizontal, 40)
                        .blur(radius: 20)
                    
                    Image(title)
                        .resizable()
                        .cornerRadius(cornerRadius)
                        .padding(.bottom, 4)
                        .opacity(testOpactiy)
                }
            }
        }
    }
}


final class CarouselCell: UICollectionViewCell {
    private let imageView = FLAnimatedImageView()
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
    
    
    func configure(with imageTitle: String, indexPath: IndexPath) {
        guard let image = UIImage(named: imageTitle) else { return }

        let gifData = try! Data(contentsOf: Bundle.main.url(forResource: "slideGif", withExtension: "gif")!)
        let gif = FLAnimatedImage(gifData: gifData)
        
        if indexPath.item.isMultiple(of: 4){
            imageView.animatedImage = gif
            reflectedImageView.image = createBluredImage(using: imageView.image!)
        } else {
            imageView.image = image
            reflectedImageView.image = createBluredImage(using: image)
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
//
//extension UIImage {
//    public class func gif(asset: String) -> UIImage? {
//        if let asset = NSDataAsset(name: asset) {
//            return UIImage.gif(data: asset.data)
//        }
//        return nil
//    }
//}
