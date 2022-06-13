//
//  GridControllerCell.swift
//  UIKitTesting
//
//  Created by Richard Witherspoon on 6/13/22.
//

import UIKit

class GridControllerCell: UICollectionViewCell {
    enum Section {
        case main
    }
    
    var dataSource: UICollectionViewDiffableDataSource<Section, Int>! = nil
    var collectionView: UICollectionView! = nil
    let stack = UIStackView()
    var shouldInvalidate : (()->Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        configureHierarchy()
        configureDataSource()
    }
    
    required init?(coder: NSCoder) {
        fatalError("not implemented")
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.25),
                                              heightDimension: .estimated(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(2),
                                               heightDimension: .estimated(1))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitems: [item])
        group.interItemSpacing = .fixed(5)

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 5
        let layout = EqualHeightsUICollectionViewCompositionalLayout(section: section, columns: 3)
        return layout
    }
    
    private func configureHierarchy() {
        collectionView = SelfSizingCollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemGroupedBackground
        collectionView.bounces = false
        collectionView.layer.borderColor = UIColor.systemGroupedBackground.cgColor
        collectionView.layer.borderWidth = 5
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .fillEqually
        
        contentView.addSubview(collectionView)
        contentView.addSubview(stack)
        
        for i in 0..<3 {
            let label = UILabel()
            label.text = "Button \(i)"
            label.backgroundColor = .lightRandom()
            label.textAlignment = .center
            stack.addArrangedSubview(label)
        }
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            collectionView.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo:  stack.leadingAnchor, constant: -5),
            
            stack.topAnchor.constraint(equalTo: contentView.topAnchor),
            stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            stack.trailingAnchor.constraint(equalTo:  contentView.trailingAnchor)
        ])
    }
    
    private func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<TableCell, Int> { [weak self] (cell, indexPath, identifier) in
            cell.configure(text: "This is it") { string in
                self?.collectionView.collectionViewLayout.invalidateLayout()
                self?.shouldInvalidate?()
            }
            cell.collectionView = self?.collectionView
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, Int>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, identifier: Int) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: identifier)
        }
    }
    
    func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Int>()
        snapshot.appendSections([.main])
        snapshot.appendItems(Array(0..<12))
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}
