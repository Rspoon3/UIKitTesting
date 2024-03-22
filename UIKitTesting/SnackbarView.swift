//
//  SnackbarView.swift
//  UIKitTesting
//
//  Created by Richard Witherspoon on 3/21/24.
//

import UIKit

class SnackbarView: UIStackView {
    let config: SnackbarViewConfig
    var buttonAction: (()-> Void)?
    var dismiss: (()-> Void)?

    init(config: SnackbarViewConfig) {
        self.config = config
        super.init(frame: .zero)

        configureViews()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureViews() {
        let image = UIImage(systemName: config.leadingImage ?? "")
        let leadingImage = UIImageView(image: image)
        leadingImage.tintColor = .white
        leadingImage.contentMode = .scaleAspectFit
        leadingImage.isHidden = config.leadingImage == nil
        
        let titleLabel = UILabel()
        titleLabel.text = config.title
        titleLabel.textColor = .white
        
        let textButton = UIButton(primaryAction: .init(handler: { [weak self] _ in
            self?.buttonAction?()
        }))
        textButton.setTitle(config.buttonTitle, for: .normal)
        textButton.setTitleColor(.white, for: .normal)
        textButton.isHidden = config.buttonTitle == nil

        let dismissButton = UIButton(primaryAction: .init(handler: { [weak self] _ in
            self?.dismiss?()
        }))
        
        dismissButton.setImage(.init(systemName: "xmark"), for: .normal)
        dismissButton.tintColor = .white
        dismissButton.isHidden = !config.showCloseButton
        
        let leadingStack = UIStackView(arrangedSubviews: [leadingImage, titleLabel])
        leadingStack.spacing = 4
        
        let trailingStack = UIStackView(arrangedSubviews: [textButton, dismissButton])
        trailingStack.spacing = 8
        
        addArrangedSubview(leadingStack)
        addArrangedSubview(trailingStack)
        layoutMargins = UIEdgeInsets(top: 14, left: 16, bottom: 14, right: 16)
        isLayoutMarginsRelativeArrangement = true
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = config.backgroundColor
        layer.cornerRadius = 8
        layer.masksToBounds = true
        distribution = .equalSpacing
        alignment = .center
        widthAnchor.constraint(equalToConstant: 343).isActive = true
    }
}


#Preview {
    let stack = UIStackView(arrangedSubviews: [
        SnackbarView(config: .previewData),
        
        SnackbarView(
            config: .init(
                leadingImage: "location",
                title: "Show everything!",
                buttonTitle: "Okay",
                showCloseButton: true,
                backgroundColor: .systemMint
            )
        ),
        
        SnackbarView(
            config: .init(
                leadingImage: nil,
                title: "Ricky is great",
                buttonTitle: "Okay",
                showCloseButton: true,
                backgroundColor: .systemBlue
            )
        ),
        
        SnackbarView(
            config: .init(
                leadingImage: "car",
                title: "It's almost Friday",
                buttonTitle: "Okay",
                showCloseButton: false,
                backgroundColor: .systemPurple
            )
        ),
        
        SnackbarView(
            config: .init(
                leadingImage: "calendar",
                title: "No trailing components",
                buttonTitle: nil,
                showCloseButton: false,
                backgroundColor: .systemOrange
            )
        ),
        
        SnackbarView(
            config: .init(
                leadingImage: nil,
                title: "Just text",
                buttonTitle: nil,
                showCloseButton: false,
                backgroundColor: .systemBrown
            )
        )
    ])
    stack.axis = .vertical
    stack.spacing = 10
    return stack
}

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
