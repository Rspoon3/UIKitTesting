//
//  ViewController.swift
//  UIKitTesting
//
//  Created by Richard Witherspoon on 3/1/22.
//

import UIKit

class ViewController: UIViewController {
    private var collectionView: UICollectionView! = nil
    var dataSource: UICollectionViewDiffableDataSource<String, Node<String>>! = nil
    
    let root = Node("Terry") {
        Node("Paul") {
            Node("Sophie")
            Node("Timmy")
            Node("Sandra") {
                Node("Aimee")
                Node("Niki")
            }
            Node("Bob")
        }

        Node("Andrew") {
            Node("John")
            Node("Adam")
            Node("Suzzie")
            Node("Ricky"){
                Node("Taylor")
                Node("Megan")
                Node("Arthur") {
                    Node("Fred")
                    Node("George")
                    Node("Giny") {
                        Node("Harry")
                        Node("Harold")
                    }
                }
            }
        }
    }
    
    
    //MARK: - View
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        configureDataSource()
        applySnapshot(animated: false)
    }
    
    private func configureCollectionView() {
        var config = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        config.headerMode = .firstItemInSection
        let layout = UICollectionViewCompositionalLayout.list(using: config)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemBackground
        
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    
    //MARK: - Data Source
    func configureDataSource() {
        let mainRegistration = createMainRegistration()
        let headerRegistration = createHeaderRegistration()
        
        dataSource = UICollectionViewDiffableDataSource<String, Node<String>>(collectionView: collectionView) { (collectionView, indexPath, node) -> UICollectionViewCell? in
            
            return collectionView.dequeueConfiguredReusableCell(using: mainRegistration, for: indexPath, item: node)
        }
        
        dataSource?.supplementaryViewProvider = { (view, kind, index) in
            return self.collectionView.dequeueConfiguredReusableSupplementary(using:headerRegistration, for: index)
        }
    }
    
    private func createHeaderRegistration() -> UICollectionView.SupplementaryRegistration<UICollectionViewListCell> {
        UICollectionView.SupplementaryRegistration <UICollectionViewListCell>(elementKind: UICollectionView.elementKindSectionHeader) { [weak self] (headerView, elementKind, indexPath) in
            guard
                let self = self,
                let sectionTitle = self.dataSource?.snapshot().sectionIdentifiers[indexPath.section]
            else { fatalError() }
            
            var configuration: UIListContentConfiguration!
            
            if #available(iOS 15.0, *) {
                configuration = UIListContentConfiguration.prominentInsetGroupedHeader()
            } else {
                configuration = UIListContentConfiguration.sidebarHeader()
            }
            
            configuration.text = sectionTitle
            headerView.contentConfiguration = configuration
        }
    }

    
    private func createMainRegistration()-> UICollectionView.CellRegistration<UICollectionViewListCell, Node<String>> {
        UICollectionView.CellRegistration { (cell, indexPath, node) in
            var content = cell.defaultContentConfiguration()
            content.text = node.value
            content.textProperties.numberOfLines = 0
            
            cell.contentConfiguration = content
            
            
            cell.accessories = [.outlineDisclosure(displayed: .always,
                                                   options: .init(style: .header, isHidden: node.children.isEmpty))]
        }
    }
    
    fileprivate func extractedFunc(_ child: Node<String>, _ sectionSnapshot: inout NSDiffableDataSourceSectionSnapshot<Node<String>>) {
        for subChild in child.children {
            sectionSnapshot.append(subChild.children, to: subChild)
            extractedFunc(subChild, &sectionSnapshot)
        }
    }
    
    func applySnapshot(animated: Bool) {
        
        for child in root.children{
            var sectionSnapshot = NSDiffableDataSourceSectionSnapshot<Node<String>>()
            sectionSnapshot.append([child])
//            
            sectionSnapshot.append(child.children, to: child)
            
            
            extractedFunc(child, &sectionSnapshot)
            
            
            sectionSnapshot.expand(sectionSnapshot.items)
            dataSource.apply(sectionSnapshot, to: child.value, animatingDifferences: animated)
        }
    }
}



