//
//  ColorVC.swift
//  UIKitTesting
//
//  Created by Richard Witherspoon on 3/14/24.
//

import UIKit

class ColorVC: UIViewController {
    let color: UIColor
    
    init(color: UIColor) {
        self.color = color
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = color
    }
}
