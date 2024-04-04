//
//  SnackbarViewConfig.swift
//  UIKitTesting
//
//  Created by Richard Witherspoon on 3/28/24.
//

import UIKit

struct SnackbarViewConfig {
    let leadingImage: String?
    let title: String
    let buttonTitle: String?
    let showCloseButton: Bool
    let backgroundColor: UIColor
    
    // MARK: - Preview Data
    
    static let previewData = SnackbarViewConfig(
        leadingImage: "info.circle",
        title: "Snackbar title",
        buttonTitle: nil,
        showCloseButton: true,
        backgroundColor: .darkGray
    )
}
