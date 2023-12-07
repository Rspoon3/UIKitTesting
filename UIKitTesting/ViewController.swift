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
        //Cannon
//        CelebrationConfetti.performConfetti(on: view)
        
        //rain
        Task {
            let test = CelebrationView(hapticsManager: HapticsManager.shared)
            try await test.present(on: view)
        }
        
        // desired
//        let confettiPresenter = ConfettiPresenter()
//        confettiPresenter.present(type: .cannonBlast, on: view, using: HapticsManager.shared)
    }
}
