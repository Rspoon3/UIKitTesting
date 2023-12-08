//
//  ConfettiPresenter.swift
//  UIKitTesting
//
//  Created by Richard Witherspoon on 12/7/23.
//

import UIKit

@MainActor
struct ConfettiPresenter {
    func present(confettiType: ConfettiKind, on view: UIView) async throws {
        switch confettiType {
        case .rainFall(let bottomView, let duration):
            let celebrationRainView = CelebrationRainView(hapticsManager: HapticsManager.shared)
            try await celebrationRainView.present(on: view, belowView: bottomView, duration: duration)
        case .cannonBlast:
            let celebrationConfettiView = CelebrationConfettiView()
            try await celebrationConfettiView.present(on: view)
        }
    }
}
