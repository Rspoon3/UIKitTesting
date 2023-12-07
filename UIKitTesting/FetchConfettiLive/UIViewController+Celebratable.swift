//
//  UIViewController+Celebratable.swift
//  FetchHop
//
//  Created by Stanley Traub on 2/18/21.
//  Copyright © 2021 Fetch Rewards, LLC. All rights reserved.
//

import UIKit

extension UIViewController: Celebratable {
    
    @MainActor
    public func performCelebration() {
        view.performCelebration()
    }
}
