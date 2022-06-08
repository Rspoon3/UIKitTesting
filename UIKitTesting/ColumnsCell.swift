//
//  TextCell.swift
//  UIKitTesting
//
//  Created by Richard Witherspoon on 6/7/22.
//

import UIKit
import LoremSwiftum

class ColumnsCell: UICollectionViewCell, UIScrollViewDelegate {
    static let reuseIdentifier = "text-cell-reuse-identifier"
    var labels = [UILabel]()
    let scrollView = UIScrollView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure(count: 4)
    }
    
    required init?(coder: NSCoder) {
        fatalError("not implemented")
    }
    
    func configure(count: Int) {
        scrollView.backgroundColor = .systemBlue
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.delegate = self
        scrollView.contentSize = .init(width: 2000, height: 0)
        scrollView.showsHorizontalScrollIndicator = false
        contentView.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: contentView.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
        
        for _ in 0..<count{
            let m = CGFloat(1) / CGFloat(count)

            let label = UILabel()
            label.numberOfLines = 0
            label.font = .preferredFont(forTextStyle: .title1)
            label.text = Lorem.sentences(3)
            label.translatesAutoresizingMaskIntoConstraints = false
            label.backgroundColor = .random()
            scrollView.addSubview(label)
            
            NSLayoutConstraint.activate([
                label.topAnchor.constraint(equalTo: contentView.topAnchor),
                label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
                label.widthAnchor.constraint(equalToConstant: 500),
            ])
            
            if let last = labels.last{
                label.leadingAnchor.constraint(equalTo: last.trailingAnchor).isActive = true
            } else {
                label.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
            }

            labels.append(label)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print(scrollView.contentOffset.x)
    }
}
