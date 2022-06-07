//
//  ViewController.swift
//  UIKitTesting
//
//  Created by Richard Witherspoon on 3/1/22.
//

import UIKit
import LoremSwiftum
//https://stackoverflow.com/questions/71918534/make-nscollectionlayoutitem-heights-as-tall-as-the-nscollectionlayoutgroup-when

class ViewController: UIViewController {
    
    let sentences = [
        "This is a short sentence for a short string",
        "This week is WWDC and Im hoping that I can get some help with this long sentence so that it resizes properly. Maybe this should just be its own api? Idk I just need a long sentence for this to resize properly. Please be long enough now.",
        "I was able to mock this expected behavior by changing the NSCollectionLayoutSize to be an absolute value of 500. This is not what I want."
    ]
    
    enum Section {
        case main
    }
    
    var dataSource: UICollectionViewDiffableDataSource<Section, String>! = nil
    var collectionView: UICollectionView! = nil
    let sectionBackgroundDecorationElementKind = "section-background-element-kind"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Two-Column Grid"
        configureHierarchy()
        configureDataSource()
    }
    
    /// - Tag: TwoColumn
    func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.2),
                                             heightDimension: .estimated(22))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .estimated(22))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,subitem: item, count: 1)
        let section = NSCollectionLayoutSection(group: group)

        section.interGroupSpacing = 10
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        let config = UICollectionViewCompositionalLayoutConfiguration()
        layout.configuration = config
        return layout
    }
    
    func configureHierarchy() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .systemBackground
        view.addSubview(collectionView)
    }
    
    func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<ColumnsCell, String> { [weak self] (cell, indexPath, string) in
            // Populate the cell with our item description.
//            cell.configure(count: Int.random(in: 2..<5))
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, String>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, string: String) -> UICollectionViewCell? in
            // Return the cell.
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: string)
        }
        
        // initial data
        var snapshot = NSDiffableDataSourceSnapshot<Section, String>()
        snapshot.appendSections([.main])
        snapshot.appendItems(sentences)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}
