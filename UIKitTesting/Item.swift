//
//  Item.swift
//  UIKitTesting
//
//  Created by Richard Witherspoon on 7/28/22.
//

import Foundation

struct Item: Identifiable, Hashable {
    let id = UUID()
    let text: String
    let subItems: [String]
    
    init(number: Int) {
        self.text = number.description
        self.subItems = Array(1..<Int.random(in: 2..<50)).map{ i in
            "This is item \(number.description).\(i)"
        }
    }
}
