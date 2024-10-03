//
//  ViewController.swift
//  UIKitTesting
//
//  Created by Richard Witherspoon on 3/1/22.
//

import SwiftUI
import Combine

class ViewController: UIViewController  {
    private var dataSource: UICollectionViewDiffableDataSource<Section, String>! = nil
    private var collectionView: UICollectionView! = nil
    private let items = Array(1...100).map{"This is item \($0)"}
    private var customSearchController: CustomSearchController!

    enum Section: String {
        case main
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "List"
        configureCollectionView()
        configureDataSource()
        applyInitialSnapshot()
        configureSearchController()
    }
    
    func configureSearchController(){
        customSearchController = CustomSearchController(searchResultsController: GridVC())
        customSearchController.delegate = self
        
        navigationItem.searchController = customSearchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
        
    private func createLayout() -> UICollectionViewLayout {
        let config = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        return UICollectionViewCompositionalLayout.list(using: config)
    }
    
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .systemBackground
        view.addSubview(collectionView)
    }
    
    private func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, String> { (cell, indexPath, item) in
            var content = cell.defaultContentConfiguration()
            content.text = item
            cell.contentConfiguration = content
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, String>(collectionView: collectionView) {
            (collectionView, indexPath, identifier) -> UICollectionViewCell? in
            
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: identifier)
        }
    }
    
    private func applyInitialSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, String>()
        snapshot.appendSections([.main])
        snapshot.appendItems(items)
        
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}

extension ViewController: UISearchControllerDelegate {
    func willDismissSearchController(_ searchController: UISearchController) {
        print(searchController.isActive, #function)
        
      
    }
    
    func willPresentSearchController(_ searchController: UISearchController) {
        print(searchController.isActive, #function)
    }
    
    func didPresentSearchController(_ searchController: UISearchController) {
        print(searchController.isActive, #function)
    }
}



