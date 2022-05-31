//
//  SectionBackgroundDecorationView.swift
//  UIKitTesting
//
//  Created by Richard Witherspoon on 5/31/22.
//

import UIKit


class SectionBackgroundDecorationView: UICollectionReusableView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.black
    }
    
    required init?(coder: NSCoder) {
        fatalError("not implemented")
    }
}
