//
//  ConfettiPresenter.swift
//  UIKitTesting
//
//  Created by Richard Witherspoon on 12/7/23.
//

import UIKit

/// An object that handles presenting confetti
@MainActor
struct ConfettiPresenter {
    func present(confettiType: ConfettiKind, on view: UIView) async throws {
        switch confettiType {
        case .cannonBlast:
            let celebrationConfettiView = CelebrationConfettiView()
            try await celebrationConfettiView.present(on: view)
        }
    }
}
