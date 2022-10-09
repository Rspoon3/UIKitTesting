//
//  DetailsVC.swift
//  UIKitTesting
//
//  Created by Richard Witherspoon on 10/7/22.
//

import UIKit

class DetailsVC: UIViewController, ListVCDelegate {
    private let label = UILabel()
    var text: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.title = "Details"
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = text ?? "NA"
        label.textAlignment = .center
        label.font = .preferredFont(forTextStyle: .largeTitle)
        
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: view.topAnchor),
            label.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            label.trailingAnchor.constraint(equalTo:  view.trailingAnchor)
        ])
    }
    
    func didSelect(item: String) {
        text = item
        label.text = text
    }
}
