//
//  ViewController.swift
//  UIKitTesting
//
//  Created by Richard Witherspoon on 3/1/22.
//

import SwiftUI

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.backgroundColor = .systemOrange.withAlphaComponent(0.3)
        
        let chevronLeft = UIImage(systemName: "car.circle")!
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = chevronLeft
        imageView.layer.borderWidth = 1
        imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        container.addSubview(imageView)
        view.addSubview(container)
        
        NSLayoutConstraint.activate([
            container.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            container.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            container.heightAnchor.constraint(equalToConstant: 200),
            container.widthAnchor.constraint(equalToConstant: 200),
        ])
    }
}

#Preview {
    ViewController()
}

#Preview {
    Image(systemName: "car.circle")
        .resizable()
        .scaledToFit()
        .frame(width: 200, height: 200)
        .background(Color.orange.opacity(0.3))
}
