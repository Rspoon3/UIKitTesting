//
//  PillLabel.swift
//  UIKitTesting
//
//  Created by Richard Witherspoon on 7/22/22.
//

import UIKit


class PillLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.masksToBounds = true
        textAlignment = .center
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.height / 2
    }
    
    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        let maximum = max(size.height, size.width)
        
        print(size.height, size.width)
        
        if size.height > size.width {
            let size = CGSize(width: maximum + size.width / 2,
                              height: maximum + size.width / 2)
            print(size)
            return size
        } else {
            let size = CGSize(width: maximum + size.height / 1.5,
                              height: size.height + size.height / 3)
            print(size)
            return size
        }
    }
}
