//
//  UIBarButtonItem+Extension.swift
//  BoardBookit
//
//  Created by Richard Witherspoon on 3/14/22.
//  Copyright © 2022 BoardBookit. All rights reserved.
//

import UIKit

extension UIBarButtonItem{
    public convenience init(systemItem: UIBarButtonItem.SystemItem, handler: @escaping UIActionHandler){
        let action = UIAction(handler: handler)
        self.init(systemItem: systemItem, primaryAction: action)
    }
    
    public convenience init(image: UIImage?, tintColor: UIColor? = nil, handler: @escaping UIActionHandler){
        let action = UIAction(handler: handler)
        self.init(image: image, primaryAction: action)
        self.tintColor = tintColor
    }
    
    public convenience init(title: String, tintColor: UIColor? = nil, isEnabled: Bool = true, handler: @escaping UIActionHandler){
        let action = UIAction(handler: handler)
        self.init(title: title, primaryAction: action)
        self.tintColor = tintColor
        self.isEnabled = isEnabled
    }
}
