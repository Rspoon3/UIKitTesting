//
//  ListVC.swift
//  UIKitTesting
//
//  Created by Richard Witherspoon on 10/7/22.
//

import UIKit

protocol ListVCDelegate: AnyObject {
    func didSelect(item: String)
}

class ListVC: UIViewController, UICollectionViewDelegate {
    var dataSource: UICollectionViewDiffableDataSource<Section, String>! = nil
    var collectionView: UICollectionView! = nil
    var items = Array(1...100).map{"This is item \($0)"}
    weak var delegate: ListVCDelegate?

    enum Section: String {
        case main
    }
    
    
    //MARK: - Initializer
    init(delegate: ListVCDelegate) {
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - View
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "List"
        configureCollectionView()
        configureDataSource()
        applyInitialSnapshot()
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let config = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        return UICollectionViewCompositionalLayout.list(using: config)
    }
    
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        view.addSubview(collectionView)
    }
    
    
    //MARK: - Data Source
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
    
    
    //MARK: - UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let rowText = dataSource?.itemIdentifier(for: indexPath) else { return }
        delegate?.didSelect(item: rowText)
        
        if let detailViewController = delegate as? DetailsVC,
           let detailNavigationController = detailViewController.navigationController {
            splitViewController?.showDetailViewController(detailNavigationController, sender: nil)
        }
    }
}
