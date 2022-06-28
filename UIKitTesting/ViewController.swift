//
//  ViewController.swift
//  UIKitTesting
//
//  Created by Richard Witherspoon on 3/1/22.
//

import UIKit

class ViewController: UIViewController, SpreadsheetCollectionViewLayoutInvalidationDelegate, GridControllerCellDelegate {
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

        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        else {
            // if keyboard size is not available for some reason, dont do anything
            return
        }
        
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height , right: 0.0)
        
        collectionView.contentInset = contentInsets
        collectionView.scrollIndicatorInsets = contentInsets
        
//        let activeRect = collectionView.convert(collectionView.bounds, to: collectionView)
//        collectionView.scrollRectToVisible(activeRect, animated: true)
        
//        collectionView.setContentOffset(.init(x: 0, y: -(collectionView.frame.origin.y - keyboardSize.height)), animated: true)
    }
    
    
    @objc func keyboardWillHide(notification: NSNotification) {
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        
        collectionView.contentInset = contentInsets
        collectionView.scrollIndicatorInsets = contentInsets
    }
    
    func hasFinishedInvalidating() {
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let config = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
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
        
        coordinator.animate { _ in
            
        } completion: { _ in
            NotificationCenter.default.post(name: .init(rawValue: "GridViewChanged"), object: nil)
        }
    }
    
    func scrollToBottom() {
        let ip = dataSource.snapshot().itemIdentifiers.count
        collectionView.scrollToItem(at: IndexPath(item: ip - 1, section: 0), at: .bottom, animated: true)
    }
    
    private func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, String> { (cell, indexPath, item) in
            var content = cell.defaultContentConfiguration()
            content.text = "\(item)"
            cell.contentConfiguration = content
        }
        
        let gridCellRegistration = UICollectionView.CellRegistration<GridControllerCell, Int> { [weak self] (cell, indexPath, item) in
            cell.layout.invalidationDelegate = self
            cell.delegate = self
            DispatchQueue.main.async {
                cell.collectionView.collectionViewLayout.invalidateLayout()
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
