//
//  ViewController.swift
//  UIKitTesting
//
//  Created by Richard Witherspoon on 3/1/22.
//

import SwiftUI

class ViewController: UIViewController, UISearchResultsUpdating, UISearchControllerDelegate  {
    private var testView: UIButton?
    private var leadingAnchor: NSLayoutConstraint?
    private var dataSource: UICollectionViewDiffableDataSource<Section, String>! = nil
    private var collectionView: UICollectionView! = nil
    private let items = Array(1...100).map{"This is item \($0)"}
    let chevronButton = UIImageView(image: .init(systemName: "chevron.left"))
    var magImage: UIView?

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
        
//        definesPresentationContext = true
    }
    
    func configureSearchController(){
        let searchController = UISearchController(searchResultsController: GridVC())
        searchController.delegate = self
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search for a username"
        searchController.definesPresentationContext = true
        
        configure(searchController.searchBar) {
            searchController.isActive = false
        }
        
//        searchController.obscuresBackgroundDuringPresentation = false
//        searchController.automaticallyShowsCancelButton = false
//        searchController.showsSearchResultsController = true
//        
//        searchController.searchBar.backgroundColor = .systemRed
//        searchController.searchBar.searchTextField.backgroundColor = .systemGreen
//        
//        searchController.searchBar.layoutMargins = .init(top: 30, left: 30, bottom: 0, right: 0)
//        searchController.searchBar.layoutIfNeeded()

//        UISearchBar.appearance().setPositionAdjustment(UIOffset(horizontal: 8, vertical: 0), for: .search)

        
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    func updateSearchResults(for searchController: UISearchController) {
    }
    
    func willPresentSearchController(_ searchController: UISearchController) {
        setLightBorder(searchBar: searchController.searchBar)
    }
    
    func willDismissSearchController(_ searchController: UISearchController) {
        setDarkBorder(searchBar: searchController.searchBar)
    }
    
    private func configure(_ searchBar: UISearchBar, close: @escaping () -> Void) {
        print("configure")

        let searchTextField = searchBar.searchTextField
        
        if let transButton = searchTextField.leftView {
            let tap = BindableGestureRecognizer {
                close()
            }
            
            transButton.isUserInteractionEnabled = true;
            transButton.addGestureRecognizer(tap)
            searchBar.setImage(UIImage(systemName: "magnifyingglass"), for: .search, state: .normal)
            transButton.translatesAutoresizingMaskIntoConstraints = false
            transButton.contentMode = .scaleAspectFit
//            transButton.isHidden = true
//            transButton.backgroundColor = .red
            magImage = transButton
            
            chevronButton.translatesAutoresizingMaskIntoConstraints = false
            chevronButton.contentMode = .scaleAspectFit
            chevronButton.isUserInteractionEnabled = false
            chevronButton.alpha = 1
            chevronButton.backgroundColor = .systemBlue
            
            transButton.addSubview(chevronButton)
            
            NSLayoutConstraint.activate([
                chevronButton.topAnchor.constraint(equalTo: transButton.topAnchor),
                chevronButton.bottomAnchor.constraint(equalTo: transButton.bottomAnchor),
                chevronButton.leadingAnchor.constraint(equalTo: transButton.leadingAnchor),
                chevronButton.trailingAnchor.constraint(equalTo: transButton.trailingAnchor)
            ])
            
//            transButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
//            transButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
//            transButton.centerYAnchor.constraint(equalTo: searchBar.searchTextField.centerYAnchor).isActive = true
        }
        
        searchBar.setImage(UIImage(systemName: "xmark"), for: .clear, state: .normal)
        
        if let clearButton = searchTextField.value(forKey: "_clearButton") as? UIButton {
           clearButton.tintColor = .red
        }
        
        searchBar.setPositionAdjustment(UIOffset(horizontal: -10, vertical: 0), for: .clear)
        
        searchBar.setPositionAdjustment(UIOffset(horizontal: 10, vertical: 0), for: .search)
        searchBar.searchTextPositionAdjustment.horizontal = 4
        let height: CGFloat = 44
        
        searchTextField.borderStyle = .none
        searchTextField.layer.cornerRadius = height / 2
        searchTextField.backgroundColor = .white
        
        searchTextField.layer.borderWidth = 1
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        
        if let imageView = searchBar.searchTextField.leftView as? UIImageView {
//            imageView.backgroundColor = .systemGreen
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.widthAnchor.constraint(equalToConstant: 24).isActive = true
            imageView.heightAnchor.constraint(equalToConstant: 24).isActive = true
        }
        
        let image = UIImage(systemName: "star")
        testView = UIButton(primaryAction: nil)
        guard let testView else { return }
        
        testView.translatesAutoresizingMaskIntoConstraints = false
        testView.setImage(image, for: .normal)
        testView.backgroundColor = .systemGreen
        
        searchBar.addSubview(testView)
        
//        let barButtonAppearanceInSearchBar: UIBarButtonItem?
//        barButtonAppearanceInSearchBar = UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self])
//        barButtonAppearanceInSearchBar?.image = UIImage(systemName: "car")?.withRenderingMode(.alwaysTemplate)
//        barButtonAppearanceInSearchBar?.tintColor = UIColor.white
//        barButtonAppearanceInSearchBar?.title = nil
        
//        trailingAnchor = testView.trailingAnchor.constraint(equalTo: searchBar.trailingAnchor, constant: -16)
        leadingAnchor = testView.leadingAnchor.constraint(equalTo: searchBar.trailingAnchor, constant: -46)
        
        guard let leadingAnchor else { return }
        
        NSLayoutConstraint.activate([
            testView.heightAnchor.constraint(equalToConstant: 30),
            testView.widthAnchor.constraint(equalToConstant: 30),
            testView.centerYAnchor.constraint(equalTo: searchTextField.centerYAnchor),
            leadingAnchor,
            
            searchTextField.heightAnchor.constraint(equalToConstant: height),
            searchTextField.leadingAnchor.constraint(equalTo: searchBar.leadingAnchor, constant: 16),
            searchTextField.trailingAnchor.constraint(equalTo: testView.leadingAnchor, constant: -16),
            searchTextField.topAnchor.constraint(equalTo: searchBar.topAnchor)
        ])
        
        searchBar.backgroundColor = .red
    }
    
    private func setDarkBorder(searchBar: UISearchBar) {
        print("setDarkBorder")

        searchBar.searchTextField.layer.borderColor = UIColor.gray.cgColor
        
        guard let testView else { return }
        leadingAnchor?.isActive = false
        leadingAnchor = testView.leadingAnchor.constraint(equalTo: searchBar.trailingAnchor, constant: -46)
        leadingAnchor?.isActive = true
        
        UIView.animate(withDuration: 0.25) {
            self.chevronButton.image = UIImage(systemName: "chevron.left")
            
//            searchBar.superview?.layoutIfNeeded()
//            self.chevronButton.alpha = 0
//            searchBar.setImage(UIImage(systemName: "magnifyingglass"), for: .search, state: .normal)

//            self.magImage?.alpha = 1
//            searchBar.searchTextField.leftView?.alpha = 1
//            searchBar.searchTextField.layoutIfNeeded()
        }
    }
    
    private func setLightBorder(searchBar: UISearchBar) {
        print("setLightBorder")

        guard let testView else { return }
        leadingAnchor?.isActive = false
        leadingAnchor = testView.leadingAnchor.constraint(equalTo: searchBar.trailingAnchor)
        leadingAnchor?.isActive = true
        
        UIView.animate(withDuration: 0.25) {
            self.chevronButton.image = UIImage(systemName: "chevron.left")

            
//            searchBar.superview?.layoutIfNeeded()
//            searchBar.setImage(UIImage(systemName: "chevron.left"), for: .search, state: .normal)

//            self.chevronButton.alpha = 1
//            self.magImage?.alpha = 0
//            searchBar.searchTextField.leftView?.alpha = 0
//            searchBar.searchTextField.layoutIfNeeded()
        }
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
