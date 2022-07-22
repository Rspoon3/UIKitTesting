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
        view.backgroundColor = .systemBackground
        
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 10
        stack.alignment = .center
        
        let numbers = [1,8,14, 22, 78, 999, 368, 12345, 8748329]
        
        for number in numbers {
            let label = PillLabel()
            label.text = number.formatted()
            label.backgroundColor = .systemBlue.withAlphaComponent(0.8)
            label.font = .preferredFont(forTextStyle: .caption1)
            label.textColor = .white
            label.translatesAutoresizingMaskIntoConstraints = false
            
            let textLabel = UILabel()
            textLabel.font = .preferredFont(forTextStyle: .headline)
            textLabel.text = "Attending Remotely"
            
            let headerStack = UIStackView(arrangedSubviews: [textLabel, label])
            headerStack.spacing = 12
            headerStack.backgroundColor = .systemGroupedBackground
            headerStack.alignment = .center
            headerStack.translatesAutoresizingMaskIntoConstraints = false
            headerStack.heightAnchor.constraint(equalToConstant: 50).isActive = true
            
            label.heightAnchor.constraint(greaterThanOrEqualTo: textLabel.heightAnchor).isActive = true
            label.widthAnchor.constraint(greaterThanOrEqualTo: textLabel.heightAnchor).isActive = true
            
            //            label.heightAnchor.constraint(greaterThanOrEqualToConstant: 30).isActive = true
            //            label.widthAnchor.constraint(greaterThanOrEqualToConstant: 30).isActive = true
            
            stack.addArrangedSubview(headerStack)
        }
        
        view.addSubview(stack)
        
        stack.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stack.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
}
