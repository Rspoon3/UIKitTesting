//
//  ViewController.swift
//  UIKitTesting
//
//  Created by Richard Witherspoon on 3/1/22.
//

import UIKit

class ViewController: UIViewController {
    private var collectionView: UICollectionView! = nil
    private var dataSource: UICollectionViewDiffableDataSource<Section, Node<String>>! = nil
    private enum Section { case main }
    private var indentDictionary: [UUID: Int] = [:]
    
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
        let layout = UICollectionViewCompositionalLayout() { sectionIndex, layoutEnvironment in
            var configuration = UICollectionLayoutListConfiguration(appearance: .plain)
            configuration.showsSeparators = false

            let section = NSCollectionLayoutSection.list(using: configuration,
                                                         layoutEnvironment: layoutEnvironment)
            section.interGroupSpacing = 5
            
            return section
        }
        
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
        
        dataSource = UICollectionViewDiffableDataSource<Section, Node<String>>(collectionView: collectionView) { (collectionView, indexPath, node) -> UICollectionViewCell? in
            
            return collectionView.dequeueConfiguredReusableCell(using: mainRegistration, for: indexPath, item: node)
        }
    }
    
    private func createMainRegistration()-> UICollectionView.CellRegistration<IndentCell, Node<String>> {
        UICollectionView.CellRegistration { [weak self] (cell, indexPath, node) in
            guard
                let self = self,
                let indentValue = self.indentDictionary[node.id]
            else { return }
            
            
            cell.configure(text: node.value,
                           indentLevel: indentValue,
                           color: node.children?.isEmpty ?? true ? .label : .red)
        }
    }
    
    func applySnapshot(animated: Bool) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Node<String>>()
        snapshot.appendSections([.main])
        
        snapshot.appendItems(root.recursiveChildren)
        dataSource.apply(snapshot, animatingDifferences: false)
        
        getIndentationValue(for: root)
    }
    
    private func getIndentationValue(for node: Node<String>, value: Int = 0) {
        guard let children = node.children else { return }
        
        indentDictionary[node.id] = value
        
        for child in children {
            indentDictionary[child.id] = value
            getIndentationValue(for: child, value: value + 1)
        }
    }
}
