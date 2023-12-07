//
//  CelebrationConfetti.swift
//  
//
//  Created by Richard Witherspoon on 11/2/23.
//

import UIKit

final class CelebrationConfetti {

    @MainActor 
    static func performConfetti(on view: UIView) {
        view.addSubview(CelebrationConfettiView(type: .confetti))
    }
}
