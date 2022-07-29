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
    private var collectionViewHeightConstraint: NSLayoutConstraint?
    private var collectionViewImageYConstraint: NSLayoutConstraint?
    private var collectionViewImageView = UIImageView()
    private var stack: UIStackView!
    weak var delegate: SimpleListCellDelegate?
    var ip: IndexPath!
    var string = [String]()
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        collectionView.layoutIfNeeded()
        collectionViewHeightConstraint?.constant = collectionView.collectionViewLayout.collectionViewContentSize.height
        
        collectionViewImageYConstraint?.isActive = false
        let cell = collectionView.cellForItem(at: IndexPath(item: 0, section: 0))!
        collectionViewImageYConstraint = collectionViewImageView.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor)
        collectionViewImageYConstraint?.isActive = true
        
        return super.preferredLayoutAttributesFitting(layoutAttributes)
        
    }
    
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
        
        collectionViewImageView = UIImageView(image: UIImage(systemName: "star"))
        collectionViewImageView.contentMode = .scaleAspectFit
        collectionViewImageView.translatesAutoresizingMaskIntoConstraints = false
        collectionViewImageView.setContentCompressionResistancePriority(.required, for: .horizontal)

        let imageContainer = UIView()
        imageContainer.addSubview(collectionViewImageView)
        imageContainer.setContentCompressionResistancePriority(.required, for: .horizontal)
        imageContainer.translatesAutoresizingMaskIntoConstraints = false

        
        let collectionStack = UIStackView(arrangedSubviews: [imageContainer, collectionView])
        collectionStack.alignment = .top
        collectionStack.backgroundColor = .yellow

        stack = UIStackView(arrangedSubviews: [label, collectionStack])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.backgroundColor = .purple
        contentView.addSubview(stack)
        
        collectionViewHeightConstraint = collectionView.heightAnchor.constraint(equalToConstant: 44)
        collectionViewHeightConstraint?.priority = .defaultHigh
        
        collectionViewImageYConstraint = collectionViewImageView.centerYAnchor.constraint(equalTo: collectionView.centerYAnchor)
        
        let padding: CGFloat = 10
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding),
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            stack.trailingAnchor.constraint(equalTo:  contentView.trailingAnchor, constant: -padding),
            collectionViewHeightConstraint!,
            
            collectionViewImageYConstraint!,
            collectionViewImageView.leadingAnchor.constraint(equalTo: imageContainer.leadingAnchor),
            collectionViewImageView.trailingAnchor.constraint(equalTo: imageContainer.trailingAnchor),
            
            imageContainer.widthAnchor.constraint(equalTo: collectionViewImageView.widthAnchor)
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
        self.string = items
        label.text = items.count.description
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, String>()
        snapshot.appendSections([.main])
        snapshot.appendItems(items)
        
        dataSource.apply(snapshot, animatingDifferences: false)
    }

    
    
    //MARK: - UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath)
//        var snapshot = NSDiffableDataSourceSnapshot<Section, String>()
//        snapshot.appendSections([.main])
//        snapshot.appendItems(Array(string.prefix(4)))
//        dataSource.apply(snapshot, animatingDifferences: false)
//
//        collectionView.setNeedsLayout()
//        collectionView.layoutIfNeeded()
//        setNeedsLayout()
//        layoutIfNeeded()
//
//        delegate?.reconfigure(ip: ip)
    }
}
