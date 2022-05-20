//
//  Node.swift
//  UIKitTesting
//
//  Created by Richard Witherspoon on 5/19/22.
//

import Foundation

@resultBuilder
struct NodeBuilder {
    static func buildBlock<Value>(_ children: Node<Value>...) -> [Node<Value>] {
        children
    }
}

struct Node<Value>: Identifiable {
    var value: Value
    private(set) var children: [Node]
    var id = UUID()
    
    mutating func add(child: Node) {
        children.append(child)
    }
    
    init(_ value: Value) {
        self.value = value
        children = []
    }

    init(_ value: Value, children: [Node]) {
        self.value = value
        self.children = children
    }
    
    init(_ value: Value, @NodeBuilder builder: () -> [Node]) {
        self.value = value
        self.children = builder()
    }
    
    var count: Int {
        1 + children.reduce(0) { $0 + $1.count }
    }
    
    var recursiveChildren: [Node] {
        return [self] + children.flatMap { $0.recursiveChildren }
    }
    
    func depthFirstTraversal(visit: (Node) -> Void) {
        visit(self)
        children.forEach {
            $0.depthFirstTraversal(visit: visit)
        }
    }
    
}

extension Node where Value == String {
    func getHierarchy() -> [(Node<String>, Node<String>)] {
        children.map{ node in
            (self, node)
        } + children.flatMap{ $0.getHierarchy() }
    }
}



extension Node: Equatable where Value: Equatable { }
extension Node: Hashable where Value: Hashable { }
extension Node: Codable where Value: Codable { }
