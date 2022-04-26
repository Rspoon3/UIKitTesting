//
//  DirectoryCell.swift
//  BoardBookit
//
//  Created by Richard Witherspoon on 4/25/22.
//  Copyright © 2022 BoardBookit. All rights reserved.
//

import UIKit


class DirectoryCell: UICollectionViewListCell {
    private var name: String!
    private var email: String!
    private var groups: String!
    
    
    //MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: .zero)
        backgroundColor = .systemBackground
        layer.masksToBounds = true
        
        if #available(iOS 15.0, *) {
            focusEffect = nil
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    override var isSelected: Bool{
//        didSet {
//            layer.borderWidth = isSelected ? 4 : 0
//            layer.borderColor = UIColor.purple.cgColor
//        }
//    }
    
    //MARK: - Public Funcitons
    func configure(name: String?,
                   email: String,
                   groups: String?){
        self.name = name
        self.email = email
        self.groups = groups
    }
    
    
    override func updateConfiguration(using state: UICellConfigurationState) {
        var backgroundConfig = UIBackgroundConfiguration.listGroupedCell()
        let config = DirectoryCellConfig(name: name,
                                         email: email,
                                         groups: groups)
        
        let updatedConfig = config.updated(for: state)
        
        backgroundConfig.backgroundColor = .systemBlue
        
        if state.isSelected {
            backgroundConfig.strokeColor = .purple
            backgroundConfig.strokeWidth = 4
            print("isSelected")
        }
        
        if state.isEditing{
            print("isEditing")
        }
        
        if state.isHighlighted {
            print("isHighlighted")
        }
        
        if state.isDisabled {
            print("isDisabled")
        }
            
        backgroundConfiguration = backgroundConfig
        contentConfiguration = updatedConfig
    }
}

struct DirectoryCellConfig: UIContentConfiguration, Hashable{
    let name: String?
    let email: String
    let groups: String?
    
    
    //MARK: - Functions
    func makeContentView() -> UIView & UIContentView {
        return DirectoryCellContentView(configuration: self)
    }
    
    func updated(for state: UIConfigurationState) -> DirectoryCellConfig {
        self
    }
}

class DirectoryCellContentView: UIView,  UIContentView {
    private let signatureIcon = UILabel()
    private let nameLabel     = UILabel()
    private let emailLabel   = UILabel()
    private let groupsLabel   = UILabel()
    private var currentConfiguration: DirectoryCellConfig!
    
    var configuration: UIContentConfiguration {
        get {
            currentConfiguration
        }
        set {
            if let newConfiguration = newValue as? DirectoryCellConfig{
                apply(newConfiguration)
            }
        }
    }
    
    
    //MARK: - Initializer
    init(configuration: DirectoryCellConfig) {
        super.init(frame:.zero)
        
        addViews()
        apply(configuration)
    }
    
    required init?(coder: NSCoder) {
        fatalError("not implemented")
    }
    
    
    //MARK: - Private Views
    private func addViews() {
        nameLabel.font = .preferredFont(forTextStyle: .title3)
        nameLabel.numberOfLines = 2

        emailLabel.numberOfLines = 2

        groupsLabel.numberOfLines = 2
        
        let verticalStack = UIStackView()
        verticalStack.axis = .vertical
        verticalStack.spacing = 8
        verticalStack.alignment = .leading
        verticalStack.addArrangedSubview(nameLabel)
        verticalStack.addArrangedSubview(emailLabel)
        verticalStack.addArrangedSubview(groupsLabel)
        
        let horizontalStack = UIStackView()
        horizontalStack.translatesAutoresizingMaskIntoConstraints = false
        horizontalStack.alignment = .leading
        horizontalStack.spacing = layoutMargins.right
        horizontalStack.addArrangedSubview(signatureIcon)
        horizontalStack.addArrangedSubview(verticalStack)
        
        addSubview(horizontalStack)
        
        let padding: CGFloat = 16
        NSLayoutConstraint.activate([
            horizontalStack.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            horizontalStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding),
            horizontalStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            horizontalStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding)
        ])
    }
    
    private func apply(_ configuration: DirectoryCellConfig) {
        guard currentConfiguration != configuration else {
            return
        }
        
        currentConfiguration = configuration
        
        
        
        if let name = configuration.name {
            nameLabel.isHidden = false
            nameLabel.text = name
        } else {
            nameLabel.isHidden = true
        }
        
        emailLabel.text = configuration.email
        
        if let groups = configuration.groups, !groups.isEmpty {
            groupsLabel.isHidden = false
            groupsLabel.text = configuration.groups
        } else {
            groupsLabel.isHidden = true
        }
    }
}

//
//#if canImport(SwiftUI) && DEBUG
//import SwiftUI
//
//struct DirectoryCell_Previews: PreviewProvider {
//    static var previews: some View {
//        UIViewPreview {
//            let cell = DirectoryCell()
//            cell.configure(name: "Richard Witherspoon",
//                           email: "rwitherspoon@govenda.com",
//                           groups: "Board of Directors, Odd It Group, test redirect, retest")
//            return cell
//        }
//        .previewLayout(.sizeThatFits)
//        .frame(maxWidth: 300, maxHeight: 170)
//        .padding(10)
//        .background(Color(.tertiarySystemGroupedBackground))
//    }
//}
//#endif
//
