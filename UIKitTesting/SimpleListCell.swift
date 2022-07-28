//
//  SimpleListCell.swift
//  UIKitTesting
//
//  Created by Richard Witherspoon on 7/28/22.
//

import UIKit
import Combine

protocol SimpleListCellDelegate: AnyObject {
    func invalidateLayout()
    func reconfigure(ip: IndexPath)
}

class SimpleListCell: UICollectionViewListCell, UICollectionViewDelegate {
    private var dataSource: UICollectionViewDiffableDataSource<Section, String>! = nil
    private var collectionView: UICollectionView! = nil
    private let label = UILabel()
    private var c: NSLayoutConstraint!
    private var stack: UIStackView!
    weak var delegate: SimpleListCellDelegate?
    var ip: IndexPath!
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCollectionView()
        configureDataSource()
        contentView.backgroundColor = .systemGreen
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    enum Section: String {
        case main
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(44), heightDimension: .estimated(44))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = .fixed(10)
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 10
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemBlue
        collectionView.isScrollEnabled = false
        collectionView.delegate = self
        
        label.font = .preferredFont(forTextStyle: .largeTitle)
        
        stack = UIStackView(arrangedSubviews: [label, collectionView])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        contentView.addSubview(stack)
        
        c = collectionView.heightAnchor.constraint(equalToConstant: 44)
        c.priority = .defaultHigh
        
        let padding: CGFloat = 10
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding),
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            stack.trailingAnchor.constraint(equalTo:  contentView.trailingAnchor, constant: -padding),
            c
        ])
    }
    
    private func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, String> { (cell, indexPath, item) in
            var content = cell.defaultContentConfiguration()
            content.text = item
            content.textProperties.font = .preferredFont(forTextStyle: .footnote)
            content.textProperties.color = .white
            cell.contentConfiguration = content
            
            var config = cell.backgroundConfiguration
            config?.backgroundColor = .systemRed
            cell.backgroundConfiguration = config
            
            cell.layer.masksToBounds = true
            cell.layer.cornerRadius = 4
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, String>(collectionView: collectionView) {
            (collectionView, indexPath, identifier) -> UICollectionViewCell? in
            
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: identifier)
        }
    }
    
    func applyInitialSnapshot(using items: [String]) {
        label.text = items.count.description
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, String>()
        snapshot.appendSections([.main])
        snapshot.appendItems(items)
        
        dataSource.apply(snapshot, animatingDifferences: false){ [weak self] in
            self?.updateHeightConstraint()
        }
    }
    
    private func updateHeightConstraint() {
        collectionView.layoutIfNeeded()
        let height = collectionView.collectionViewLayout.collectionViewContentSize.height
        c.constant = height
        delegate?.reconfigure(ip: ip)
//        delegate?.invalidateLayout()

    }
    
    
    //MARK: - UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        updateHeightConstraint()
    }
}
