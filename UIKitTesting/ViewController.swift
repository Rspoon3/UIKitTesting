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
        case table
    }
    var dataSource: UICollectionViewDiffableDataSource<Section, AnyHashable>! = nil
    var collectionView: UICollectionView! = nil
    var items = Array(0..<8).map{"This is item \($0)"}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "List"
        
        configureHierarchy()
        configureDataSource()
    }
    
    private func createLayout() -> UICollectionViewLayout {
        var config = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        config.showsSeparators = true
        return UICollectionViewCompositionalLayout.list(using: config)
    }
    
    private func configureHierarchy() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo:  view.trailingAnchor),
        ])
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        coordinator.animate { [weak self] _ in
            guard let self = self else { return }
            var snapshot = self.dataSource.snapshot()
            snapshot.reconfigureItems(snapshot.itemIdentifiers(inSection: .table))
            self.dataSource.apply(snapshot)
        }
    }
    
    private func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, String> { (cell, indexPath, item) in
            var content = cell.defaultContentConfiguration()
            content.text = "\(item)"
            cell.contentConfiguration = content
        }
        
        let gridCellRegistration = UICollectionView.CellRegistration<VoteResultsCollectionViewCell, Int> { [weak self] (cell, indexPath, item) in
            guard
                let self = self,
                let layout = cell.collectionView.collectionViewLayout as? SpreadsheetCollectionViewLayout
            else {
                return
            }
            
            layout.invalidationDelegate = self
            
            DispatchQueue.main.async {
                cell.collectionView.collectionViewLayout.invalidateLayout()
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
        snapshot.appendSections([.main, .table])
        snapshot.appendItems(items, toSection: .main)
        
        snapshot.appendItems([1], toSection: .table)
        
        
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}


extension ViewController: SpreadsheetCollectionViewLayoutInvalidationDelegate {
    func hasFinishedInvalidating() {
        collectionView.collectionViewLayout.invalidateLayout()
    }
}
