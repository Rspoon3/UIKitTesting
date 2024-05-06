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
    let chevronButton = UIImageView(image: .init(systemName: "chevron.left"))
    private var searchController: UISearchController!
    private var subscriptions = Set<AnyCancellable>()
    private var mySearchBar: MySearchBar?

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
//        configureSearchController()
        configureSwiftUISearchBar()
        
//        searchController.searchBar.translatesAutoresizingMaskIntoConstraints = false
//        for c in searchController.searchBar.subviews {
//            print(c.constraints)
//        }
//        
//        let anchor = searchController.searchBar.heightAnchor.constraint(equalToConstant: 300)
//        anchor.priority = .required
//        
//        anchor.isActive = true
////        searchController.searchBar.layer.borderWidth = 1
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
        searchController = UISearchController(searchResultsController: UIViewController())
        
        mySearchBar = MySearchBar(searchController: searchController)

        mySearchBar?.textChangePublisher
            .sink(receiveValue: { text in
//                print(text, 2)
            }).store(in: &subscriptions)
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.mySearchBar?.removePlaceholder()
//        }
    }
    
    private func configureSwiftUISearchBar() {
        searchController = UISearchController(searchResultsController: UIViewController())
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.automaticallyShowsCancelButton = false
        searchController.showsSearchResultsController = true
        searchController.searchBar.searchTextField.removeFromSuperview()
        searchController.searchBar.gestureRecognizers = nil
        
        let vc = UIHostingController(rootView: SwiftUISearchBar(searchController: searchController))
        
        let swiftuiView = vc.view!
        swiftuiView.translatesAutoresizingMaskIntoConstraints = false
        
        searchController.searchBar.addSubview(vc.view)
        
        NSLayoutConstraint.activate([
            swiftuiView.topAnchor.constraint(equalTo: searchController.searchBar.topAnchor),
            swiftuiView.bottomAnchor.constraint(equalTo: searchController.searchBar.bottomAnchor),
            swiftuiView.leadingAnchor.constraint(equalTo: searchController.searchBar.leadingAnchor),
            swiftuiView.trailingAnchor.constraint(equalTo: searchController.searchBar.trailingAnchor)
        ])
        
        navigationItem.searchController = searchController
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
