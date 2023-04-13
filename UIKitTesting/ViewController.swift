//
//  ViewController.swift
//  UIKitTesting
//
//  Created by Richard Witherspoon on 3/1/22.
//
import UIKit

struct Person {
    let name: String?
    let height: Int?
    let age: Int
}


class ViewController: UIViewController {
    
    let people = [
        Person(name: nil, height: nil, age: 1),
        Person(name: nil, height: nil, age: 2),
        Person(name: "Ricky", height: 3, age: 2),
        Person(name: "Ricky", height: 3, age: 3),
        Person(name: "Ricky", height: 1, age: 4),
        Person(name: "Ricky", height: 3, age: 4),
        Person(name: "Ricky", height: nil, age: 12),
        Person(name: nil, height: nil, age: 12),
        Person(name: "Amanda", height: nil, age: 3),
        Person(name: nil, height: 33, age: 1),
        Person(name: nil, height: 78, age: 1),
        Person(name: nil, height: 12, age: 1),
        Person(name: "Amanda", height: 1, age: 4),
        Person(name: "Amanda", height: 4, age: 9),
        Person(name: "Ted", height: nil, age: 10),
        Person(name: "Ted", height: nil, age: 1),
        Person(name: nil, height: 33, age: 14),
        Person(name: nil, height: 99, age: 21),
        Person(name: nil, height: 42, age: 1),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
        let sorted = people.sorted(using: [
            KeyPathComparator(forwardOptionalLastUsing: \.name),
            KeyPathComparator(\.height, order: .reverse),
            KeyPathComparator(\.age, order: .reverse),
        ])
        
        for item in sorted {
            print(item)
        }
    }
}



extension KeyPathComparator {
    public init<Value: Comparable>(forwardOptionalLastUsing keyPath: KeyPath<Compared, Value?>) {
        self.init(keyPath, comparator: OptionalComparator(), order: SortOrder.forward)
    }
    
    private struct OptionalComparator<T:Comparable>: SortComparator {
        var order: SortOrder = .forward
        
        func compare(_ lhs: T?, _ rhs: T?) -> ComparisonResult {
            switch (lhs, rhs) {
            case (nil, nil):
                return .orderedSame
            case (.some, nil):
                return .orderedAscending
            case (nil, .some):
                return .orderedDescending
            case let (lhs?, rhs?):
                if let lhs = lhs as? String, let rhs = rhs as? String {
                    return lhs.localizedStandardCompare(rhs)
                } else if lhs < rhs {
                    return .orderedAscending
                } else if rhs > lhs {
                    return .orderedDescending
                } else {
                    return .orderedSame
                }
            }
        }
    }
}
