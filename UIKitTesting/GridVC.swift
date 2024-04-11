//
//  GridVC.swift
//  UIKitTesting
//
//  Created by Richard Witherspoon on 3/14/24.
//

import UIKit

final class GridVC: UIViewController, UICollectionViewDelegate {
    private var dataSource: UICollectionViewDiffableDataSource<Section, String>! = nil
    private var collectionView: UICollectionView! = nil
    private let items = Array(1...100).map{$0.formatted()}
    
    enum Section: String {
        case main
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Grid"
        configureCollectionView()
        configureDataSource()
        applyInitialSnapshot()
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.2),
            heightDimension: .fractionalHeight(1.0))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        item.contentInsets = NSDirectionalEdgeInsets(
            top: 5,
            leading: 5,
            bottom: 5,
            trailing: 5
        )
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalWidth(0.2)
        )
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        view.addSubview(collectionView)
        
//        definesPresentationContext = true

    }
    
    private func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<TextCell, String> { (cell, indexPath, item) in
            cell.contentView.backgroundColor = .systemBlue
            cell.label.text = item
            cell.label.textColor = .white
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

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        self.presentingViewController?.navigationController?.pushViewController(ColorVC(color: .red), animated:true)
//        (parent as? UISearchController)?.isActive = false
    }
}
