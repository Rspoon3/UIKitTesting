//
//  ViewController.swift
//  UIKitTesting
//
//  Created by Richard Witherspoon on 3/1/22.
//

import UIKit

@MainActor
class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        Task {
            let presenter = ConfettiPresenter()
            try await presenter.present(confettiType: .cannonBlast, on: view)
        }
    }
}
