//
//  ViewController.swift
//  UIKitTesting
//
//  Created by Richard Witherspoon on 3/1/22.
//

import UIKit

class ViewController: UIViewController {
    private var collectionView: UICollectionView! = nil
    var dataSource: UICollectionViewDiffableDataSource<Section, Node<String>>! = nil
    enum Section { case main }
    var indentDictionary: [UUID: Int] = [:]
    
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
            
            
            cell.configure(text: node.value, indentLevel: indentValue, color: node.children.isEmpty ? .label : .red)
        }
    }
    
    func applySnapshot(animated: Bool) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Node<String>>()
        snapshot.appendSections([.main])
        
        snapshot.appendItems(root.recursiveChildren)
        dataSource.apply(snapshot, animatingDifferences: false)
        
        bedTimeOld(node: root)
    }
    
    func bedTimeOld(node: Node<String>, value: Int = 0) {
        indentDictionary[node.id] = value
        
        if value == 0 {
            print(node.value)
        }
        
        for child in node.children {
            let spacing = Array(0...value).map{_ in "   "}.joined()
            indentDictionary[child.id] = value
            print(spacing, child.value)
            bedTimeOld(node: child, value: value + 1)
        }
    }
}



class IndentCell: UICollectionViewCell{
    private let textLabel = UILabel()
    private let container = UIView()
    private let padding: CGFloat = 15
    private let spacing: CGFloat = 40
    private var leadingConstraint: NSLayoutConstraint! = nil
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(text: String, indentLevel: Int, color: UIColor) {
        textLabel.text = text
        textLabel.textColor = color
        
        leadingConstraint.isActive = false
        leadingConstraint = container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                                               constant: CGFloat(indentLevel) * spacing + padding)
        leadingConstraint.isActive = true
    }
    
    private func addViews(){
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.font = .preferredFont(forTextStyle: .headline)
        
        container.backgroundColor = .systemGray6
        container.translatesAutoresizingMaskIntoConstraints = false
        
        container.addSubview(textLabel)
        contentView.addSubview(container)
        
        leadingConstraint = container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor)

        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: contentView.topAnchor),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            leadingConstraint,
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            
            textLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: padding),
            textLabel.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -padding),
            textLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: padding),
            textLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -padding),
        ])
    }
}
