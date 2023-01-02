//
//  ColorStackView.swift
//  UIKitTesting
//
//  Created by Richard Witherspoon on 12/31/22.
//

import UIKit

final class ColorStackView: UIView {
    private var stack: UIStackView!
    private let widths: CGFloat = 12

    override init(frame: CGRect) {
        super.init(frame: frame)
    
        let blue = UIView()
        blue.backgroundColor = .systemBlue
        let red = UIView()
        red.backgroundColor = .systemRed
        
        stack = UIStackView(arrangedSubviews: [blue, red])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = 0
        stack.distribution = .fillEqually
        
        addSubview(stack)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addAndConstraint(to view: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(self)

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: view.topAnchor),
            stack.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stack.widthAnchor.constraint(equalToConstant: widths * CGFloat(stack.arrangedSubviews.count))
        ])
    }
}
