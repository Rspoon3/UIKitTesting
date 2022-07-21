//
//  PaddedLabel.swift
//  UIKitTesting
//
//  Created by Richard Witherspoon on 7/21/22.
//

import UIKit

class PaddedLabel: UILabel {
    let topInset:    CGFloat
    let bottomInset: CGFloat
    let leftInset:   CGFloat
    let rightInset:  CGFloat
    
    init(padding: CGFloat) {
        topInset    = padding
        bottomInset = padding
        leftInset   = padding
        rightInset  = padding
        super.init(frame: .zero)
    }
    
    init(top: CGFloat, bottom: CGFloat, left: CGFloat, right: CGFloat) {
        topInset    = top
        bottomInset = bottom
        leftInset   = left
        rightInset  = right
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets.init(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: rect.inset(by: insets))
    }
    
    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + leftInset + rightInset,
                      height: size.height + topInset + bottomInset)
    }
}

