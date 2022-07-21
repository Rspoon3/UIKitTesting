//
//  ListCell.swift
//  UIKitTesting
//
//  Created by Richard Witherspoon on 7/21/22.
//

import UIKit


class ListCell: UICollectionViewListCell {
    var imageTask : Task<Void, Error>?
    var image: UIImage?
                            
    //MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        var content = defaultContentConfiguration()
        
        content.imageProperties.reservedLayoutSize = .init(width: 40, height: 40)
        content.imageProperties.maximumSize = .init(width: 40, height: 40)
        contentConfiguration = content


    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageTask?.cancel()
        imageTask = nil
    }
    
    
    //MARK: - Public Helpers
    func configure(text: String) {
        guard image == nil else {
            return
        }
        
        var content = defaultContentConfiguration()
        content.text = text
        
        imageTask = Task {
            let url = URL(string: "https://picsum.photos/id/\(Int.random(in: 1...800))/100/100")!
            let (data,_) = try await URLSession.shared.data(from: url)
            if let image = UIImage(data: data) {
                self.image = image
                content.image = image
                content.imageProperties.cornerRadius = 20
                contentConfiguration = content
            }
        }

        let button = UIButton()
        let action1 = UIAction(title: "Test 1"){_ in }
        let action2 = UIAction(title: "Test 1"){_ in }
        let action3 = UIAction(title: "Test 1"){_ in }
        button.menu = .init(title: "", children: [action1, action2, action3])
        button.showsMenuAsPrimaryAction = true
        button.setImage(UIImage(systemName: "pencil"), for: .normal)

        let test = UICellAccessory.CustomViewConfiguration(customView: button, placement: .trailing(), tintColor: .secondaryLabel)
        accessories = [.customView(configuration: test)]
        contentConfiguration = content
    }
}
