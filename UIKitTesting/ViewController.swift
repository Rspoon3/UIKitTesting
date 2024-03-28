//
//  ViewController.swift
//  UIKitTesting
//
//  Created by Richard Witherspoon on 3/1/22.
//

import SwiftUI

class ViewController: UIViewController, UISearchResultsUpdating, UISearchControllerDelegate  {
    private var dataSource: UICollectionViewDiffableDataSource<Section, String>! = nil
    private var collectionView: UICollectionView! = nil
    private let items = Array(1...100).map{"This is item \($0)"}
    let chevronButton = UIImageView(image: .init(systemName: "chevron.left"))
    private var searchController: UISearchController!
    let fake = FakeSearchBar()
    
    var shouldShowWhenAppear = false

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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard shouldShowWhenAppear else { return }
        UIView.performWithoutAnimation {
            self.searchController.searchBar.text = "asdf"
            self.searchController.isActive = true
        }
    }
    
    func configureSearchController(){
        searchController = UISearchController(searchResultsController: GridVC())
        searchController.delegate = self
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search for a username"
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.automaticallyShowsCancelButton = false
        searchController.showsSearchResultsController = true
        searchController.searchBar.backgroundColor = .systemRed
        
//        shouldShowWhenAppear = true
        
//        DispatchQueue.main.asyncAfter(deadline: .now()) {
//            self.searchController.isActive = true
//        }
//        searchController.searchBar.text = "asdf"
//        searchController.isActive = true
//        searchController.searchBar.becomeFirstResponder()
        
//        searchController.searchBar.searchTextField.removeFromSuperview()
//        fake.configure(using: searchController)
        
        
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    func updateSearchResults(for searchController: UISearchController) {
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
