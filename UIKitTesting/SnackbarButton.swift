//
//  SnackbarButton.swift
//  UIKitTesting
//
//  Created by Richard Witherspoon on 1/26/24.
//

import UIKit

class SnackbarButton: UIButton {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setTitle("Testing", for: .normal)
        setTitleColor(.systemBlue, for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

#Preview {
    SnackbarButton(frame: .init(x: 0, y: 0, width: 100, height: 100))
}
