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
        
//        if let image = cropImage(UIImage(named: "Slide-4")!) {
//            setupImageView(using: image)
//        }
        
        setupImageView(using: UIImage(named: "Slide-10")!)
        
        print(UIScreen.main.scale, UIScreen.main.nativeScale)
    }
    
    func cropImage(_ sourceImage: UIImage) -> UIImage? {
        // The shortest side
        let sideLength = min(
            sourceImage.size.width,
            sourceImage.size.height
        )

        // Determines the x,y coordinate of a centered
        // sideLength by sideLength square
        let sourceSize = sourceImage.size
        let xOffset = (sourceSize.width - sideLength) / 2.0
        let yOffset = (sourceSize.height - sideLength) / 2.0

        // The cropRect is the rect of the image to keep,
        // in this case centered
        let cropRect = CGRect(
            x: 0,
            y: 0,
            width: sourceSize.width,
            height: sourceSize.width / 2
        ).integral

        // Center crop the image
        let sourceCGImage = sourceImage.cgImage!
        let croppedCGImage = sourceCGImage.cropping(
            to: cropRect
        )!
        
        let croppedImage: UIImage = UIImage(cgImage: croppedCGImage)
        return croppedImage
    }
    
    private func setupImageView(using image: UIImage) {
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
//        imageView.contentMode = .scaleAspectFill
//        imageView.clipsToBounds = true
        imageView.layer.borderColor = UIColor.systemGreen.cgColor
//        imageView.layer.borderWidth = 1
//        imageView.image = nil
        
        let bluredImage = UIImageView(image: blur(image: image))
        bluredImage.translatesAutoresizingMaskIntoConstraints = false
        bluredImage.layer.borderColor = UIColor.systemBlue.cgColor
//        bluredImage.layer.borderWidth = 1
        
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
//        container.layer.borderWidth = 1
        container.layer.borderColor = UIColor.red.cgColor
        
        view.addSubview(container)
        container.addSubview(bluredImage)
        view.addSubview(imageView)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1/2),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            container.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 24),
            container.heightAnchor.constraint(equalTo: imageView.heightAnchor),
            container.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            container.trailingAnchor.constraint(equalTo: imageView.trailingAnchor),
            
            bluredImage.topAnchor.constraint(equalTo: container.topAnchor,constant: -24),
            bluredImage.bottomAnchor.constraint(equalTo: container.bottomAnchor,constant: 24),
            bluredImage.leadingAnchor.constraint(equalTo: container.leadingAnchor,constant: -24),
            bluredImage.trailingAnchor.constraint(equalTo: container.trailingAnchor,constant: 24),
        ])
    }
    
    private func blur(image: UIImage, inputRadius: CGFloat = 24) -> UIImage? {
        guard let currentFilter = CIFilter(name: "CIGaussianBlur") else {
            return nil
        }
        guard let beginImage = CIImage(image: image) else {
            return nil
        }
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        currentFilter.setValue(inputRadius, forKey: kCIInputRadiusKey)
        guard let output = currentFilter.outputImage else {
            return nil
        }
        
        let context = CIContext()
        
        guard let final = context.createCGImage(output, from: output.extent) else {
            return nil
        }
        
        return UIImage(cgImage: final)
    }
}

