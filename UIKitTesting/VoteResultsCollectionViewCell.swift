//
//  VoteResultsCollectionViewCell.swift
//  UIKitTesting
//
//  Created by Richard Witherspoon on 6/13/22.
//

import UIKit
import LoremSwiftum

struct TextItem: Identifiable, Hashable{
    let id = UUID()
    let text: String
    let bold: Bool
    
    init(_ text: String, bold: Bool = false){
        self.text = text
        self.bold = bold
    }
}

class VoteResultsCollectionViewCell: UICollectionViewCell, UICollectionViewDelegate, SpreadsheetCollectionViewLayoutDelegate {
    var numberOfSections = 2
    let layout = SpreadsheetCollectionViewLayout()
    var collectionView: SelfSizingCollectionView!
    var dataSource: UICollectionViewDiffableDataSource<UUID, TextItem>! = nil

    
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
        let footerRegistration = createFooterRegistration()
        let cellRegistration = UICollectionView.CellRegistration<TextItemCell, TextItem> { (cell, indexPath, item) in
            cell.configure(item: item,
                           backgroundColor: indexPath.section.isMultiple(of: 2) ? .lightText : .systemBackground)
        }
        
        dataSource = UICollectionViewDiffableDataSource<UUID, TextItem>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, item: TextItem) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
        }
        
        dataSource?.supplementaryViewProvider = { [unowned self] collectionView, kind, indexPath in
            return self.supplementary(collectionView: collectionView, kind: kind, indexPath: indexPath)
        }
        
//        dataSource?.supplementaryViewProvider = { [weak self] (view, kind, index) in
//            self?.collectionView.dequeueConfiguredReusableSupplementary(using:footerRegistration, for: index)
//        }
    }
    
    func supplementary(collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView? {
        collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter,
                                                        withReuseIdentifier: VoteCommentFooterReusableView.reuseIdentifier,
                                                        for: indexPath) as! VoteCommentFooterReusableView
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        fatalError()
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath) {
        fatalError()
    }
    
    private func createFooterRegistration() -> UICollectionView.SupplementaryRegistration<UICollectionViewListCell> {
        UICollectionView.SupplementaryRegistration <UICollectionViewListCell>(elementKind: UICollectionView.elementKindSectionFooter) { (footerView, elementKind, indexPath) in
            var configuration = UIListContentConfiguration.plainFooter()
            configuration.text = "Voting Has Closed"
            footerView.contentConfiguration = configuration
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
            snapshot.appendSections([section])
            snapshot.appendItems([TextItem("\(i + 1)"),
                                  TextItem("33.3%"),
                                  TextItem("\(Int.random(in: 0...9999))")],
                                 toSection: section)
        }
 
        
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    private func addViews() {
        layout.delegate = self
        collectionView = SelfSizingCollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemGroupedBackground
        collectionView.isDirectionalLockEnabled = true
        collectionView.bounces = false
        
        collectionView.register(
            VoteCommentFooterReusableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: VoteCommentFooterReusableView.reuseIdentifier
        )
        
        contentView.addSubview(collectionView)
        
        let padding: CGFloat = 10
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: padding),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding),
            collectionView.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: padding),
            collectionView.trailingAnchor.constraint(equalTo:  contentView.safeAreaLayoutGuide.trailingAnchor, constant: -padding),
        ])
    }
    
    
    //MARK: - SpreadsheetCollectionViewLayoutDelegate
    func width(forColumn column: Int, collectionView: UICollectionView) -> CGFloat {
        let width = collectionView.frame.width / 3
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




class VoteCommentFooterReusableView: UICollectionReusableView {
    static var reuseIdentifier: String {
        return String(describing: VoteCommentFooterReusableView.self)
      }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        addViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func addViews() {
        backgroundColor = .red
    }
}

