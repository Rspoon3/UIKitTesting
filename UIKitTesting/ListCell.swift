//
//  ListCell.swift
//  UIKitTesting
//
//  Created by Richard Witherspoon on 7/21/22.
//

import UIKit


class ListCell: UICollectionViewListCell {
    private var imageTask : Task<Void, Error>?
    private let imageView = UIImageView()
    private let label = UILabel()
    private let avatarPlaceholder = UILabel()

    
    //MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageTask?.cancel()
        imageTask = nil
    }
    
    
    //MARK: - Views
    private func addViews() {
        let buttonSize: Double = 44
        let imageSize: Double = 35
        let padding: CGFloat = 10

        label.font = .preferredFont(forTextStyle: .body)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        avatarPlaceholder.textColor = .white
        avatarPlaceholder.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        avatarPlaceholder.translatesAutoresizingMaskIntoConstraints = false
        avatarPlaceholder.textAlignment = .center
        avatarPlaceholder.adjustsFontSizeToFitWidth = true
        avatarPlaceholder.minimumScaleFactor = 0.2
        
        imageView.backgroundColor = .systemGray
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = imageSize / 2
        imageView.addSubview(avatarPlaceholder)
        
        let button = UIButton()
        let action1 = UIAction(title: "Test 1"){_ in }
        let action2 = UIAction(title: "Test 1"){_ in }
        let action3 = UIAction(title: "Test 1"){_ in }
        button.menu = .init(title: "", children: [action1, action2, action3])
        button.showsMenuAsPrimaryAction = true
        button.setImage(UIImage(systemName: "pencil"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

        contentView.addSubview(imageView)
        contentView.addSubview(label)
        contentView.addSubview(button)
        
        let c = contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: buttonSize + padding * 2)
        c.priority = .defaultHigh
        
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: imageSize),
            imageView.widthAnchor.constraint(equalToConstant: imageSize),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            imageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            avatarPlaceholder.topAnchor.constraint(equalTo: imageView.topAnchor, constant: 6),
            avatarPlaceholder.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -6),
            avatarPlaceholder.leadingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: 6),
            avatarPlaceholder.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: -6),
            
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding),
            label.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: padding),

            separatorLayoutGuide.leadingAnchor.constraint(equalTo: label.leadingAnchor),
            
            button.leadingAnchor.constraint(equalTo: label.trailingAnchor, constant: padding),
            button.trailingAnchor.constraint(equalTo:  contentView.trailingAnchor, constant: -padding),
            button.heightAnchor.constraint(equalToConstant: buttonSize),
            button.widthAnchor.constraint(equalToConstant: buttonSize),
            button.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            c
        ])
    }
    
    
    //MARK: - Public Helpers
    func configure(text: String) {
        guard imageView.image == nil else {
            return
        }
        
        label.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est la"
        
        if Bool.random() {
            label.text = text
        }
        
        avatarPlaceholder.text = "RW"
        
        imageTask = Task {
            let url = URL(string: "https://picsum.photos/id/\(Int.random(in: 1...800))/100/100")!
            let (data,_) = try await URLSession.shared.data(from: url)
            if let image = UIImage(data: data) {
                imageView.image = image
                avatarPlaceholder.isHidden = true
                avatarPlaceholder.accessibilityElementsHidden = true
            } else {
                avatarPlaceholder.isHidden = false
                avatarPlaceholder.accessibilityElementsHidden = false
            }
        }
    }
}
