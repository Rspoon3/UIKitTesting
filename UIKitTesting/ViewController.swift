//
//  ViewController.swift
//  UIKitTesting
//
//  Created by Richard Witherspoon on 3/1/22.
//

import UIKit

class ViewController: UIViewController, SimpleListCellDelegate {
    var dataSource: UICollectionViewDiffableDataSource<Section, Item>! = nil
    var collectionView: UICollectionView! = nil
    var items : [Item] = Array(1...10).map{ Item(number: $0) }
    
    enum Section: String {
        case main
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "List"
        configureCollectionView()
        configureDataSource()
        applyInitialSnapshot()
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(200))
        let item = NSCollectionLayoutItem(layoutSize: size)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: size, subitems: [item])
        group.interItemSpacing = .fixed(10)
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 10
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemBackground
        
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo:  view.trailingAnchor),
        ])
    }
    
    private func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<SimpleListCell, Item> { [weak self] (cell, indexPath, item) in
            cell.applyInitialSnapshot(using: item.subItems)
            cell.delegate = self
            cell.ip = indexPath
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView) {
            (collectionView, indexPath, identifier) -> UICollectionViewCell? in
            
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: identifier)
        }
    }
    
    private func applyInitialSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([.main])
        snapshot.appendItems(items)
        
        dataSource.apply(snapshot, animatingDifferences: false){ [weak self] in
            self?.collectionView.layoutIfNeeded()
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        coordinator.animate { _ in
            
        } completion: { [weak self] _ in
            DispatchQueue.main.asyncAfter(deadline: .now()){
                self?.collectionView.collectionViewLayout.invalidateLayout()
            }
        }
    }
    
    
    //MARK: - SimpleListCellDelegate
    func reconfigure(ip: IndexPath) {
        guard let item = dataSource?.itemIdentifier(for: ip) else { return }
        
        var snapshot = dataSource.snapshot()
        snapshot.reconfigureItems([item])
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    func invalidateLayout() {
        collectionView.collectionViewLayout.invalidateLayout()
    }
}
