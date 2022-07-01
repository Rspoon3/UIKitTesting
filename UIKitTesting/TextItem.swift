//
//  TextItem.swift
//  UIKitTesting
//
//  Created by Richard Witherspoon on 7/1/22.
//

import UIKit

struct TextItem: Identifiable, Hashable{
    let id = UUID()
    let text: String
    let bold: Bool
    
    init(_ text: String, bold: Bool = false){
        self.text = text
        self.bold = bold
    }
}
