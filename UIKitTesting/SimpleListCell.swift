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
    private var stack: UIStackView!
    weak var delegate: SimpleListCellDelegate?
    var ip: IndexPath!
    var string = [String]()
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        collectionView.layoutIfNeeded()
        collectionViewHeightConstraint?.constant = collectionView.collectionViewLayout.collectionViewContentSize.height
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
        return UICollectionViewCompositionalLayout() { [weak self] sectionIndex, layoutEnvironment in
            let headerWidth: CGFloat = 30
            let spacing: CGFloat = 10
            let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(44), heightDimension: .estimated(44))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(layoutEnvironment.container.effectiveContentSize.width - headerWidth + spacing), heightDimension: .estimated(44))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            group.interItemSpacing = .fixed(10)
            
            
            print(layoutEnvironment.container.contentSize.height, Date(), "content")
            print(layoutEnvironment.container.effectiveContentSize.height, Date(), "Effective\n\n")
//
            group.edgeSpacing = NSCollectionLayoutEdgeSpacing(leading: .fixed(headerWidth + spacing),
                                                              top: nil,
                                                              trailing: nil,
                                                              bottom: nil)
            
            
            
            
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = spacing
            section.contentInsets = NSDirectionalEdgeInsets(top: spacing, leading: 0, bottom: spacing, trailing: spacing)
            
            
            let leftSize = NSCollectionLayoutSize(widthDimension: .absolute(headerWidth),
                                                  heightDimension: .fractionalHeight(0.5))
            
            let left = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: leftSize,
                                                                   elementKind: "leadingKind",
                                                                   alignment: .leading)
            section.boundarySupplementaryItems = [left]
            
            return section
        }
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
        stack.backgroundColor = .purple
        contentView.addSubview(stack)
        
        collectionViewHeightConstraint = collectionView.heightAnchor.constraint(equalToConstant: 44)
        collectionViewHeightConstraint?.priority = .defaultHigh
        
        
        let padding: CGFloat = 10
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding),
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            stack.trailingAnchor.constraint(equalTo:  contentView.trailingAnchor, constant: -padding),
            collectionViewHeightConstraint!,
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
        
        
        let headerRegistration = UICollectionView.SupplementaryRegistration<TitleSupplementaryView>(elementKind: "leadingKind") { [weak self] (supplementaryView, string, indexPath) in
            guard let self = self else { return }
            supplementaryView.backgroundColor = .lightGray
            supplementaryView.layer.borderColor = UIColor.black.cgColor
            supplementaryView.layer.borderWidth = 1.0
            
            if let cell = self.collectionView.cellForItem(at: indexPath) {
                supplementaryView.update(cell)
            }
            
        }
        
        dataSource.supplementaryViewProvider = { (view, kind, index) in
            return self.collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: index)
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
class TitleSupplementaryView: UICollectionReusableView {
    var collectionViewImageYConstraint: NSLayoutConstraint?
    var collectionViewImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func update(_ view: UIView) {
//        collectionViewImageYConstraint?.isActive = false
//        collectionViewImageYConstraint = collectionViewImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
//        collectionViewImageYConstraint?.isActive = true
    }

    private func configure() {
//        collectionViewImageView = UIImageView(image: UIImage(systemName: "star"))
//        collectionViewImageView.contentMode = .scaleAspectFit
//        collectionViewImageView.translatesAutoresizingMaskIntoConstraints = false
//
//        let imageContainer = UIView()
////        imageContainer.addSubview(collectionViewImageView)
//        imageContainer.translatesAutoresizingMaskIntoConstraints = false

        
//        collectionViewImageYConstraint = collectionViewImageView.centerYAnchor.constraint(equalTo: centerYAnchor)

//        addSubview(imageContainer)
        
        let inset = CGFloat(0)
        NSLayoutConstraint.activate([
//            imageContainer.topAnchor.constraint(equalTo: topAnchor, constant: inset),
//            imageContainer.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -inset),
//            imageContainer.leadingAnchor.constraint(equalTo: leadingAnchor, constant: inset),
//            imageContainer.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -inset),
            
//            collectionViewImageYConstraint!,
//            collectionViewImageView.leadingAnchor.constraint(equalTo: imageContainer.leadingAnchor),
//            collectionViewImageView.trailingAnchor.constraint(equalTo: imageContainer.trailingAnchor),
        ])
    }
}
