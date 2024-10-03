//
//  CustomSearchController.swift
//  UIKitTesting
//
//  Created by Ricky on 9/30/24.
//

import UIKit

class CustomSearchController: UISearchController {


    // Mark this property as lazy to defer initialization until
    // the searchBar property is called.
    private lazy var customSearchBar = CustomSearchBar()


    // Override this property to return your custom implementation.
    override var searchBar: UISearchBar { customSearchBar }
}



final class CustomSearchBar: UISearchBar {
    init() {
        super.init(frame: .zero)
        backgroundColor = .systemRed.withAlphaComponent(0.1)
        searchTextField.removeFromSuperview()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
