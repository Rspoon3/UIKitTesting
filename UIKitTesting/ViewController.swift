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
        
        NSLayoutConstraint.activate([
            stack.bottomAnchor.constraint(equalTo: imageView.topAnchor, constant: -20),
            stack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stack.widthAnchor.constraint(equalToConstant: 100),
            
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
             let cgImage = context.createCGImage(outputImage, from: .init(x: beginImage!.extent.minX, y: beginImage!.extent.minY, width: beginImage!.extent.width - 100, height: beginImage!.extent.height - 100))
         else {
             return nil
         }
         
         return UIImage(cgImage: cgImage)
     }
}

