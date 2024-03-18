//
//  BindableGestureRecognizer.swift
//  UIKitTesting
//
//  Created by Richard Witherspoon on 3/14/24.
//

import UIKit

final class BindableGestureRecognizer: UITapGestureRecognizer {
    private var action: () -> Void

    init(action: @escaping () -> Void) {
        self.action = action
        super.init(target: nil, action: nil)
        self.addTarget(self, action: #selector(execute))
    }

    @objc private func execute() {
        action()
    }
}
