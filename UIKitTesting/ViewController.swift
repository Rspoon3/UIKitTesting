//
//  ViewController.swift
//  UIKitTesting
//
//  Created by Richard Witherspoon on 3/1/22.
//

import UIKit


class ViewController: UIViewController, UICollectionViewDelegate, UIScrollViewDelegate {
    static let sectionBackgroundDecorationElementKind = "section-background-element-kind"
    var dataSource: UICollectionViewDiffableDataSource<Int, Int>! = nil
    var collectionView: UICollectionView! = nil
    let contentOffsetSynchronizer = ContentOffsetSynchronizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Orthogonal Sections"
        configureHierarchy()
        configureDataSource()
    }
    
    func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout {
            (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            let padding: CGFloat = 2
            
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.25),
                                                  heightDimension: .fractionalHeight(1))
            let leadingItem = NSCollectionLayoutItem(layoutSize: itemSize)
            
            leadingItem.contentInsets = .init(top: 0, leading: padding / 2, bottom: 0, trailing: padding / 2)
            
            let minWidth: Double = 200
            var desiredItems: Double = 4
            let frameWidth = self.view.frame.width
            
            
            while frameWidth / desiredItems < minWidth {
                desiredItems -= 1
            }
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/desiredItems),
                                                   heightDimension: .fractionalHeight(0.25))
            let containerGroup = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                                    subitem: leadingItem,
                                                                    count: 1)

            containerGroup.contentInsets = .init(top: sectionIndex == 0 ? padding : 0, leading:0, bottom: padding, trailing: 0)
            
            
            let section = NSCollectionLayoutSection(group: containerGroup)
            section.orthogonalScrollingBehavior = .groupPaging
                        
            let sectionBackgroundDecoration = NSCollectionLayoutDecorationItem.background(
                elementKind: ViewController.sectionBackgroundDecorationElementKind)
            section.decorationItems = [sectionBackgroundDecoration]
            
        
            return section
            
        }
        
        layout.register(
            SectionBackgroundDecorationView.self,
            forDecorationViewOfKind: ViewController.sectionBackgroundDecorationElementKind)
        
        return layout
    }
    
    func configureHierarchy() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        view.addSubview(collectionView)
        
        
        DispatchQueue.main.async {
            let scrollViews = self.collectionView.subviews.compactMap({$0 as? UIScrollView})

            for scrollView in scrollViews {
                self.contentOffsetSynchronizer.register(scrollView)
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollViews = collectionView.subviews.compactMap({$0 as? UIScrollView})
        
        for scrollView in scrollViews {
            self.contentOffsetSynchronizer.register(scrollView)
        }
    }
    
    
    
    var dictText: [IndexPath: String] = [:]
    
    func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<TableCell, Int> { (cell, indexPath, identifier) in
            let text = "\(indexPath.section), \(indexPath.item)"

            cell.configure(headerText: indexPath.section == 0 ? text : nil, text: self.dictText[indexPath]) { text in
                self.dictText[indexPath] = text
            }
        }
        
        dataSource = UICollectionViewDiffableDataSource<Int, Int>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, identifier: Int) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: identifier)
        }
        
        // initial data
        var snapshot = NSDiffableDataSourceSnapshot<Int, Int>()
        var identifierOffset = 0
        let itemsPerSection = 6
        for section in 0..<13 {
            snapshot.appendSections([section])
            let maxIdentifier = identifierOffset + itemsPerSection
            snapshot.appendItems(Array(identifierOffset..<maxIdentifier))
            identifierOffset += itemsPerSection
        }
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}
