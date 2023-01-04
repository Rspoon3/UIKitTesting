//
//  ViewController.swift
//  UIKitTesting
//
//  Created by Richard Witherspoon on 3/1/22.
//

import UIKit

class ViewController: UIViewController {
    var slider: UISlider!
    private let context = CIContext()
    private let filter = CIFilter(name: "CIGaussianBlur")!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imageView = UIImageView(image: .init(named: "slide1"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.black.cgColor
        
        slider = UISlider(frame: .zero, primaryAction: .init(handler: { [weak self] action in
            let slider = action.sender as! UISlider
            let value = slider.value
            imageView.image = self?.createBluredImage(using: .init(named: "slide1")!, value: CGFloat(value))
        }))
        
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.minimumValue = 0
        slider.maximumValue = 20
        
        view.addSubview(imageView)
        view.addSubview(slider)
        
        NSLayoutConstraint.activate([
            slider.bottomAnchor.constraint(equalTo: imageView.topAnchor, constant: -20),
            slider.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            slider.widthAnchor.constraint(equalToConstant: 100),
            
            imageView.widthAnchor.constraint(equalToConstant: 300),
            imageView.heightAnchor.constraint(equalToConstant: 300),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
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

