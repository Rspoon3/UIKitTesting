//
//  ViewController.swift
//  UIKitTesting
//
//  Created by Richard Witherspoon on 3/1/22.
//

import UIKit
import LoremSwiftum

class ViewController: UIViewController {
    var dataSource: UICollectionViewDiffableDataSource<Section, String>! = nil
    var collectionView: UICollectionView! = nil
    var items = Array(1...6).map{"\($0) \(Lorem.words(Int.random(in: 10...100)))"}
    var itemsTwo = Array(1...14).map{"\($0) \(Lorem.words(Int.random(in: 10...100)))"}
    var itemsThree = Array(1...7).map{"\($0) \(Lorem.words(Int.random(in: 10...100)))"}

    enum Section: String {
        case main, two, three
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "List"
        configureCollectionView()
        configureDataSource()
        applyInitialSnapshot()
    }
    
    
    private func configureCollectionView() {
        let layout = WaterfallLayout()
        layout.delegate = self
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .systemBackground
        view.addSubview(collectionView)
    }
    
    private func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<TextCell, String> { (cell, indexPath, item) in
            cell.configure(text: item)
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, String>(collectionView: collectionView) {
            (collectionView, indexPath, identifier) -> UICollectionViewCell? in
            
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: identifier)
        }
    }
    
    private func applyInitialSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, String>()
        snapshot.appendSections([.main, .two])
        snapshot.appendItems(items, toSection: .main)
        snapshot.appendItems(itemsTwo, toSection: .two)
        
        snapshot.appendSections([.three])
        snapshot.appendItems(itemsThree, toSection: .three)

        dataSource.apply(snapshot, animatingDifferences: false)
    }
}

extension ViewController: WaterfallLayoutDelegate {
    func heightForItem(at indexPath: IndexPath) -> CGFloat {
        if let cell = collectionView.cellForItem(at: indexPath) {
            
            let height = cell.contentView.systemLayoutSizeFitting(cell.frame.size).height
//            print(height)
            return height
        }
        
        return CGFloat.random(in: 100...200)
    }
}
