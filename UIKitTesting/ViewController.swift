//
//  ViewController.swift
//  UIKitTesting
//
//  Created by Richard Witherspoon on 3/1/22.
//

import UIKit

class ViewController: UIViewController {
    enum Section: String {
        case main
    }
    
    var dataSource: UICollectionViewDiffableDataSource<Section, AnyHashable>! = nil
    var collectionView: UICollectionView! = nil
    var items = Array(0..<10).map{"This is item \($0)"}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "List"
        configureHierarchy()
        configureDataSource()
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let config = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        return UICollectionViewCompositionalLayout.list(using: config)
    }
    
    private func configureHierarchy() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(collectionView)
    }
    
    private func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, String> { (cell, indexPath, item) in
            var content = cell.defaultContentConfiguration()
            content.text = "\(item)"
            cell.contentConfiguration = content
        }
        
        let gridCellRegistration = UICollectionView.CellRegistration<GridControllerCell, Int> { (cell, indexPath, item) in
            cell.applySnapshot()
            cell.shouldInvalidate = { [weak self] in
                self?.collectionView.collectionViewLayout.invalidateLayout()
            }
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, AnyHashable>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, item: AnyHashable) -> UICollectionViewCell? in
            
            if let string = item as? String {
                return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: string)
            } else if let value = item as? Int{
                return collectionView.dequeueConfiguredReusableCell(using: gridCellRegistration, for: indexPath, item: value)
            } else {
                fatalError()
            }
        }
        
        // initial data
        var snapshot = NSDiffableDataSourceSnapshot<Section, AnyHashable>()
        snapshot.appendSections([.main])
        snapshot.appendItems(items)
        snapshot.appendItems([1])
        
        
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}
