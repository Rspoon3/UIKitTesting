//
//  UICollectionView+Extension.swift
//  BoardBookit
//
//  Created by Richard Witherspoon on 4/22/22.
//  Copyright © 2022 BoardBookit. All rights reserved.
//

import UIKit


extension UICollectionView {
    func shouldBecomeFocusedOnSelection(_ value: Bool){
        setValue(value, forKey: "shouldBecomeFocusedOnSelection")
        perform(NSSelectorFromString("_setShouldBecomeFocusedOnSelection:"))
    }
}
