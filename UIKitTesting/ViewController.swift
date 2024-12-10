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
        view.backgroundColor = .white
        
        let test = LinearGradientView()
        test.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(test)
        
        NSLayoutConstraint.activate([
            test.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            test.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            test.widthAnchor.constraint(equalToConstant: 300),
            test.heightAnchor.constraint(equalToConstant: 300)
        ])
    }


}

