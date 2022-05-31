//
//  UIColor+Extension.swift
//  BoardBookit
//
//  Created by Richard Witherspoon on 4/6/22.
//  Copyright © 2022 BoardBookit. All rights reserved.
//

import UIKit


extension UIColor{
    static func random(alpha: CGFloat = 1.0)->UIColor{
        let r = CGFloat.random(in: 0...1)
        let g = CGFloat.random(in: 0...1)
        let b = CGFloat.random(in: 0...1)
        
        return UIColor(red: r, green: g, blue: b, alpha: alpha)
    }
    
    static func lightRandom()->UIColor{
        random(alpha: 0.3)
    }
}
