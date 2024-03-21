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
        
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.backgroundColor = .systemBlue.withAlphaComponent(0.3)

        let image = UIImage(systemName: "car.circle")
//        let image = UIImage(named: "chevronLeft")
        let test = UIImageView()
        test.translatesAutoresizingMaskIntoConstraints = false
        test.contentMode = .scaleAspectFit
        test.image = image//?.withAlignmentRectInsets(.init(top: 0, left: -8, bottom: 0, right: -8))
        


//        test.backgroundColor = .systemGreen.withAlphaComponent(0.5)
        
        container.addSubview(test)
        view.addSubview(container)
        
        NSLayoutConstraint.activate([
            container.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            container.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            container.heightAnchor.constraint(equalToConstant: 200),
            container.widthAnchor.constraint(equalToConstant: 200),
        ])
        
        NSLayoutConstraint.activate([
            test.topAnchor.constraint(equalTo: container.topAnchor),
            test.bottomAnchor.constraint(equalTo: container.bottomAnchor),
            test.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            test.trailingAnchor.constraint(equalTo: container.trailingAnchor)
        ])
        
    }
}

#Preview {
    ViewController()
}
