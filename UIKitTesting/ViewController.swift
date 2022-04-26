//
//  ViewController.swift
//  UIKitTesting
//
//  Created by Richard Witherspoon on 3/1/22.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate {
    enum Section {
        case main
    }
    
    var dataSource: UICollectionViewDiffableDataSource<Section, Int>! = nil
    var collectionView: UICollectionView! = nil
    var selectButton: UIBarButtonItem?
    var selectAllButton: UIBarButtonItem?

    var allItemsAreSelected: Bool{
        return collectionView.indexPathsForSelectedItems?.count == collectionView.numberOfItems(inSection: 0)
    }


    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated:animated)
        collectionView.isEditing = editing

        
        selectButton?.title = isEditing ? "Done" : "Select"
        navigationItem.leftBarButtonItem = isEditing ? selectAllButton : nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "List"
        configureCollectionView()
        configureDataSource()
        configureNavBar()
        
        collectionView.selectItem(at: .init(row: 0, section: 0), animated: false, scrollPosition: [])
    }
    
    private func configureNavBar(){
        navigationItem.title = "Directory"
        
        selectButton = UIBarButtonItem(title: "Select"){ [weak self] _ in
            guard let self = self else { return }
            self.setEditing(!self.isEditing, animated: true)
            self.navigationItem.title = self.collectionView.isEditing.description
        }
        
        let emailButton = UIBarButtonItem(systemItem: .compose) { _ in
            
        }
        
        let filterButton = UIBarButtonItem(systemItem: .refresh) { _ in
            
        }
        
        
        navigationItem.rightBarButtonItems = [UIBarButtonItem(systemItem: .flexibleSpace), emailButton, filterButton, selectButton!]
        
        selectAllButton = UIBarButtonItem(title: "Select All"){ [weak self] _ in
            guard let self = self else { return }
            let allItemsAreSelected = self.allItemsAreSelected

            self.updateSelectAllTitle()
            
            for row in 0..<self.collectionView.numberOfItems(inSection: 0) {
                let indexPath = IndexPath(row: row, section: 0)
                
                if allItemsAreSelected {
                    self.collectionView.deselectItem(at: indexPath, animated: false)
                } else {
                    self.collectionView.selectItem(at: indexPath, animated: false, scrollPosition: [])
                }
            }
        }
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, layoutEnvironment in
            
            let estimatedHeight = CGFloat(100)
            let layoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                    heightDimension: .estimated(estimatedHeight))
            let item = NSCollectionLayoutItem(layoutSize: layoutSize)
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: layoutSize,
                                                           subitem: item,
                                                           count: 1)
            let section = NSCollectionLayoutSection(group: group)
            
            var widthInsets: CGFloat = 10
            
            section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: widthInsets, bottom: 10, trailing: widthInsets)
            section.interGroupSpacing = 2
            
            return section
        }
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 25
        
        layout.configuration = config
        return layout
    }
    
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        collectionView.allowsMultipleSelection = false
        collectionView.allowsMultipleSelectionDuringEditing = true
        collectionView.selectionFollowsFocus = true
        collectionView.shouldBecomeFocusedOnSelection(true)
        
        if #available(iOS 15.0, *) {
            collectionView.allowsFocus = true
        }
        
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }

    private func updateSelectAllTitle(){
        selectAllButton?.title = allItemsAreSelected ? "Deselect All" : "Select All"
    }
    
    private func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<DirectoryCell, Int> { (cell, indexPath, item) in
            cell.configure(name: "Richard Witherspoon",
                           email: "rwitherspoon@govenda.com",
                           groups: "Board of Directors, Odd It Group, test redirect, retest")
            
            let reorder = UICellAccessory.multiselect(options: .init(tintColor: .systemGray4, backgroundColor: .systemPurple))
            cell.accessories = [reorder]
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, Int>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, identifier: Int) -> UICollectionViewCell? in
            
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: identifier)
        }
        
        
        // initial data
        var snapshot = NSDiffableDataSourceSnapshot<Section, Int>()
        snapshot.appendSections([.main])
        snapshot.appendItems(Array(0..<4))
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        updateSelectAllTitle()

//        if !isEditing {
//            collectionView.deselectItem(at: indexPath, animated: true)
//        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, shouldBeginMultipleSelectionInteractionAt indexPath: IndexPath) -> Bool {
        return true
    }

    func collectionView(_ collectionView: UICollectionView, didBeginMultipleSelectionInteractionAt indexPath: IndexPath) {
        setEditing(true, animated: true)
    }

    func collectionViewDidEndMultipleSelectionInteraction(_ collectionView: UICollectionView) {
        print("\(#function)")
    }
}
