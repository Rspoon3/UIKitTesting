//
//  VoteResultsCollectionViewCell.swift
//  UIKitTesting
//
//  Created by Richard Witherspoon on 6/13/22.
//

import UIKit

class VoteResultsCollectionViewCell: UICollectionViewCell, UICollectionViewDelegate, TableLayoutDelegate {
    private let numberOfColumns = 3
    var collectionView: SelfSizingCollectionView!
    var dataSource: UICollectionViewDiffableDataSource<UUID, TextItem>! = nil
    var label = UILabel()

    
    //MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        addViews()
        configureDataSource()
        applySnapshot()
    }
    
    required init?(coder: NSCoder) {
        fatalError("not implemented")
    }
    
    
    //MARK: - Private Helpers
    private func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<TextItemCell, TextItem> { (cell, indexPath, item) in
            cell.configure(item: item,
                           backgroundColor: indexPath.section.isMultiple(of: 2) ? .systemGroupedBackground.withAlphaComponent(0.5) : .systemBackground)
        }
        
        dataSource = UICollectionViewDiffableDataSource<UUID, TextItem>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, item: TextItem) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
        }
    }
    
    private func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<UUID, TextItem>()
        
        let section1 = UUID()
        snapshot.appendSections([section1])
        snapshot.appendItems([TextItem("Answer", bold: true),
                              TextItem("Percentage", bold: true),
                              TextItem("Number", bold: true)],
                             toSection: section1)
        
        for i in 0..<10 {
            let section = UUID()
            let numString = (i + 1).formatted()
            let loreum = "empor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur."
            snapshot.appendSections([section])
            snapshot.appendItems([TextItem(i == 3 ? loreum : numString),
                                  TextItem("33.3%"),
                                  TextItem("\(Int.random(in: 0...9999))")],
                                 toSection: section)
        }
 
        
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    private func addViews() {
        let layout = TableLayout()
        layout.delegate = self
        collectionView = SelfSizingCollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemBackground
        collectionView.isDirectionalLockEnabled = true
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Total User Voted: 1"
        
        contentView.addSubview(collectionView)
        contentView.addSubview(label)
        
        let padding: CGFloat = 10
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: padding),
            collectionView.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: padding),
            collectionView.trailingAnchor.constraint(equalTo:  contentView.safeAreaLayoutGuide.trailingAnchor, constant: -padding),
            
            label.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: padding * 2),
            label.trailingAnchor.constraint(equalTo: collectionView.trailingAnchor),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding),
        ])
    }
    
    
    //MARK: - TableLayoutDelegate
    func width(forColumn column: Int, collectionView: UICollectionView) -> CGFloat {
        let width = collectionView.frame.width / CGFloat(numberOfColumns)
        let minWidth: CGFloat = 125
        return max(width, minWidth)
    }
    
    func height(forItemAt indexPath: IndexPath, width: Double) -> CGFloat {
        guard let item = dataSource.itemIdentifier(for: indexPath) else { return 0 }
        let cell = collectionView.cellForItem(at: indexPath) as? TextItemCell

        let label = UILabel()
        label.numberOfLines = 0
        
        if item.bold {
            label.font = UIFont.preferredFont(forTextStyle: .headline)
        } else {
            label.font = UIFont.preferredFont(forTextStyle: .body)
        }
        
        if let cell = cell {
            label.text = cell.label.text
        } else {
            label.text = item.text
        }
        
        let insets = 10.0
        let width = width - insets * 2
        let size = CGSize(width: width, height: UIView.layoutFittingCompressedSize.height)
        let layoutFittingSize = label.systemLayoutSizeFitting(size,
                                                              withHorizontalFittingPriority: .required,
                                                              verticalFittingPriority: .fittingSizeLevel)
        
        let height = layoutFittingSize.height + (insets * 2)
        return height
    }
}
