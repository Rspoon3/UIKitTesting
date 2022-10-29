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
    var stack: UIStackView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(row: Int) {
        label1.isHidden = !row.isMultiple(of: 1)
        label2.isHidden = !row.isMultiple(of: 2)
        label3.isHidden = !row.isMultiple(of: 3)
        label4.isHidden = !row.isMultiple(of: 4)
        label5.isHidden = !row.isMultiple(of: 5)
        
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
        
        stack = UIStackView(arrangedSubviews: [row, label1, label2, label3, label4, label5])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 0
        stack.distribution = .fillEqually

        contentView.addSubview(stack)
        
        let bottom = stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15)
        bottom.priority = .defaultLow
        
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            bottom,
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            stack.trailingAnchor.constraint(equalTo:  contentView.trailingAnchor, constant: -15)
        ])
    }
}
