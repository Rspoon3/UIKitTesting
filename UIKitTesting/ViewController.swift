//
//  ViewController.swift
//  UIKitTesting
//
//  Created by Richard Witherspoon on 3/1/22.
//

import UIKit

class ViewController: UIViewController {
    private let context = CIContext()
    private let filter = CIFilter(name: "CIGaussianBlur")!
    private let dog = UIImage(named: "dog")!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let label = UILabel()
        label.text = "0"
        label.textAlignment = .center
        
        let imageView = UIImageView(image: dog)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.black.cgColor
//        imageView.contentMode = .scaleAspectFill
        
        let blurEffect = UIBlurEffect(style: .systemThinMaterial)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        blurEffectView.alpha = 0
        
        let slider = UISlider(frame: .zero, primaryAction: .init(handler: { [weak self] action in
            guard
                let self,
                let slider = action.sender as? UISlider
            else {
                return
            }
            
            label.text = "\(slider.value)"
            imageView.image = self.createBluredImage(using: self.dog, value: CGFloat(slider.value))
        }))
        
        slider.minimumValue = 0
        slider.maximumValue = 20

        let stack = UIStackView(arrangedSubviews: [label, slider])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical

        
        view.addSubview(imageView)
        view.addSubview(stack)
        view.addSubview(blurEffectView)
        
        
        let test = UIView()
        test.translatesAutoresizingMaskIntoConstraints = false
        test.backgroundColor = .systemRed
        view.addSubview(test)
        
        let blue = UIView()
        blue.translatesAutoresizingMaskIntoConstraints = false
        blue.backgroundColor = .systemBlue
        view.addSubview(blue)

        let blurPadding: CGFloat = CGFloat(20) / 2
        NSLayoutConstraint.activate([
            stack.bottomAnchor.constraint(equalTo: imageView.topAnchor, constant: -20),
            stack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stack.widthAnchor.constraint(equalToConstant: 100),
            
            imageView.widthAnchor.constraint(equalToConstant: 300),
            imageView.heightAnchor.constraint(equalToConstant: 300),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            test.topAnchor.constraint(equalTo: imageView.centerYAnchor),
            test.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            test.widthAnchor.constraint(equalToConstant: blurPadding),
            test.heightAnchor.constraint(equalToConstant: 300),
            
            
            blue.topAnchor.constraint(equalTo: imageView.centerYAnchor),
            blue.trailingAnchor.constraint(equalTo: imageView.trailingAnchor),
            blue.widthAnchor.constraint(equalToConstant: 20),
            blue.heightAnchor.constraint(equalToConstant: 300),
            
            
            blurEffectView.topAnchor.constraint(equalTo: imageView.topAnchor, constant: -20),
            blurEffectView.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            blurEffectView.leadingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: -20),
            blurEffectView.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 20)
            
        ])
    }

    private func createBluredImage(using image: UIImage, value: CGFloat) -> UIImage? {
         let beginImage = CIImage(image: image)
         
         filter.setValue(beginImage, forKey: kCIInputImageKey)
         filter.setValue(value, forKey: kCIInputRadiusKey)
         
         guard
             let outputImage = filter.outputImage,
             let cgImage = context.createCGImage(outputImage, from: outputImage.extent)
         else {
             return nil
         }
         
         return UIImage(cgImage: cgImage)
     }
}



extension UIImage {
    
    func blurredImageWithBlurredEdges(inputRadius: CGFloat) -> UIImage? {
        
        guard let currentFilter = CIFilter(name: "CIGaussianBlur") else {
            return nil
        }
        guard let beginImage = CIImage(image: self) else {
            return nil
        }
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        currentFilter.setValue(inputRadius, forKey: "inputRadius")
        guard let output = currentFilter.outputImage else {
            return nil
        }
        
        // UIKit and UIImageView .contentMode doesn't play well with
        // CIImage only, so we need to back the return UIImage with a CGImage
        let context = CIContext()
        
        // cropping rect because blur changed size of image
        guard let final = context.createCGImage(output, from: beginImage.extent) else {
            return nil
        }
        
        return UIImage(cgImage: final)
        
    }
}
