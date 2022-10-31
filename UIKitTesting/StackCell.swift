//
//  StackCell.swift
//  UIKitTesting
//
//  Created by Richard Witherspoon on 10/18/22.
//

import UIKit

class StackCell: UICollectionViewListCell {
    private let label1 = UILabel()
    private let label2 = UILabel()
    private let label3 = UILabel()
    private let label4 = UILabel()
    private let label5 = UILabel()
    private let row = UILabel()
    
    private var topStack: UIStackView!
    private var bottomStack: UIStackView!
    private var stack: UIStackView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        addViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(row: Int) {
//        label1.isHidden = !row.isMultiple(of: 1)
//        label2.isHidden = !row.isMultiple(of: 2)
//        label3.isHidden = !row.isMultiple(of: 3)
//        label4.isHidden = !row.isMultiple(of: 4)
//        label5.isHidden = !row.isMultiple(of: 5)
        
        topStack.isHidden = !row.isMultiple(of: 3)
        bottomStack.isHidden = !row.isMultiple(of: 5)

        self.row.text = row.description
        
        stack.spacing = 10
    }
    
    private func addViews(){
        row.font = .preferredFont(forTextStyle: .largeTitle)
        
        label1.font = .preferredFont(forTextStyle: .largeTitle)
        label2.font = .preferredFont(forTextStyle: .title1)
        label3.font = .preferredFont(forTextStyle: .title2)
        label4.font = .preferredFont(forTextStyle: .title3)
        label5.font = .preferredFont(forTextStyle: .headline)
        
        label1.text = "This is label 1"
        label2.text = "This is label 2"
        label3.text = "This is label 3"
        label4.text = "This is label 4"
        label5.text = "This is label 5"
        
        
        
        topStack = UIStackView(arrangedSubviews: [label1, label2])
        topStack.spacing = 10
        topStack.backgroundColor = .systemBlue

        bottomStack = UIStackView(arrangedSubviews: [label3, label4, label5])
        bottomStack.spacing = 10
        bottomStack.backgroundColor = .systemGreen
        
//        stack = UIStackView(arrangedSubviews: [row, label1, label2, label3, label4, label5])
        stack = UIStackView(arrangedSubviews: [row, topStack, bottomStack])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 0
        stack.alignment = .leading
        stack.backgroundColor = .systemGray4

        let container = UIView()
        container.backgroundColor = .systemPink.withAlphaComponent(0.1)
        container.translatesAutoresizingMaskIntoConstraints = false
        
        container.addSubview(stack)
        contentView.addSubview(container)
        
        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: contentView.topAnchor),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, priority: .defaultLow),
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 50),
            container.trailingAnchor.constraint(equalTo:  contentView.trailingAnchor),
            
            stack.topAnchor.constraint(equalTo: container.topAnchor, constant: 15),
            stack.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -15),
            stack.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 15),
            stack.trailingAnchor.constraint(equalTo:  container.trailingAnchor, constant: -15)
        ])
    }
}
