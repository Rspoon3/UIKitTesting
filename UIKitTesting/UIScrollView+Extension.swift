//
//  UIScrollView+Extension.swift
//  UIKitTesting
//
//  Created by Richard Witherspoon on 12/20/22.
//

import UIKit

extension UIScrollView {
    static func swizzlScrollViewWillBeginDragging() {
        guard
            let originalMethod = class_getInstanceMethod(UIScrollView.self, NSSelectorFromString("_scrollViewWillBeginDragging")),
            let swizzledMethod = class_getInstanceMethod(UIScrollView.self, #selector(swizzled_scrollViewWillBeginDragging))
        else {
            return
        }
        
        print("Swizzling scrollViewWillBeginDragging")
        method_exchangeImplementations(originalMethod, swizzledMethod)
    }
    
    @objc private func swizzled_scrollViewWillBeginDragging() {
        swizzled_scrollViewWillBeginDragging()
        print(#function, self)
    }
}
