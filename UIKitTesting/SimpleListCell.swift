//
//  SimpleListCell.swift
//  UIKitTesting
//
//  Created by Richard Witherspoon on 7/20/22.
//
import UIKit

class SimpleListCell: UICollectionViewCell {
    var dataSource: UICollectionViewDiffableDataSource<Section, String>! = nil
    var collectionView: UICollectionView! = nil
    var stack: UIStackView!
    var hasAppliedSnapshot = false
    let numberLabel = PaddedLabel(padding: 6)

    enum Section: String {
        case main
    }

    //MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)

        configureHierarchy()
        configureDataSource()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    //MARK: - Views
    private func createLayout() -> UICollectionViewLayout {
        let config = UICollectionLayoutListConfiguration(appearance: .plain)
        return UICollectionViewCompositionalLayout.list(using: config)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateNumberLabel()
    }
    
    private func updateNumberLabel() {
        if numberLabel.frame.height > numberLabel.frame.width {
            numberLabel.widthAnchor.constraint(equalToConstant: numberLabel.frame.height).isActive = true
        }
        
        numberLabel.layer.cornerRadius = numberLabel.frame.height / 2
    }
    
    private func configureHierarchy() {
        collectionView = UICollectionView(frame: contentView.bounds, collectionViewLayout: createLayout())
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        collectionView.dropDelegate = self
        collectionView.dragDelegate = self
        collectionView.dragInteractionEnabled = true
        collectionView.alwaysBounceVertical = false

        let textLabel = UILabel()
        textLabel.text = "Attended via Proxy"
        textLabel.textAlignment = .center
        textLabel.font = .preferredFont(forTextStyle: .headline)
        textLabel.textColor = .white
        
        numberLabel.textAlignment = .center
        numberLabel.font = .preferredFont(forTextStyle: .caption1)
        numberLabel.textColor = .systemGreen
        numberLabel.backgroundColor = .white
        numberLabel.layer.masksToBounds = true
        numberLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let headerStack = UIStackView(arrangedSubviews: [textLabel, numberLabel])
        headerStack.spacing = 12
        headerStack.translatesAutoresizingMaskIntoConstraints = false
        
        let header = UIView()
        header.backgroundColor = .systemGreen
        header.translatesAutoresizingMaskIntoConstraints = false
        header.addSubview(headerStack)

        stack = UIStackView(arrangedSubviews: [header, collectionView])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.layer.masksToBounds = true
        stack.layer.cornerRadius = 8
        stack.layer.borderColor = UIColor.systemBlue.cgColor

        contentView.addSubview(stack)

        let padding: CGFloat = 15
        NSLayoutConstraint.activate([
            header.heightAnchor.constraint(equalToConstant: 50),
            headerStack.centerYAnchor.constraint(equalTo: header.centerYAnchor),
            headerStack.centerXAnchor.constraint(equalTo: header.centerXAnchor),

            stack.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: padding),
            stack.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant: -padding),
            stack.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: padding),
            stack.trailingAnchor.constraint(equalTo:  contentView.safeAreaLayoutGuide.trailingAnchor, constant: -padding),
        ])
    }

    private func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<ListCell, String> { (cell, indexPath, text) in
            cell.configure(text: text)
        }

        dataSource = UICollectionViewDiffableDataSource<Section, String>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, identifier: String) -> UICollectionViewCell? in

            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: identifier)
        }
    }

    func applyInitialSnapshot() {
        guard !hasAppliedSnapshot else { return }
        hasAppliedSnapshot.toggle()

        let items = Array(1...Int.random(in: 1...100)).map{"This is item \($0)"}
        var snapshot = NSDiffableDataSourceSnapshot<Section, String>()
        snapshot.appendSections([.main])
        
//        if Bool.random() {
            snapshot.appendItems(items)
            numberLabel.text = items.count.description
//        } else {
//            numberLabel.text = "0"
//        }
//
        contentView.layoutIfNeeded()

        dataSource.apply(snapshot, animatingDifferences: false)
    }
}

extension SimpleListCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: false)
    }
}

extension SimpleListCell: UICollectionViewDropDelegate {
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        numberLabel.text = coordinator.items.count.description
        numberLabel.layoutIfNeeded()
        updateNumberLabel()
    }
    
    func collectionView(_ collectionView: UICollectionView, dropSessionDidEnter session: UIDropSession) {
        stack.layer.borderWidth = 2
    }

    func collectionView(_ collectionView: UICollectionView, dropSessionDidExit session: UIDropSession) {
        stack.layer.borderWidth = 0
    }

    func collectionView(_ collectionView: UICollectionView, dropSessionDidEnd session: UIDropSession) {
        stack.layer.borderWidth = 0
    }

    func collectionView(_ collectionView: UICollectionView, canHandle session: UIDropSession) -> Bool {
        !collectionView.hasActiveDrag
    }
}


extension SimpleListCell: UICollectionViewDragDelegate {
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let itemProvider = NSItemProvider(object: "\(indexPath.item)" as NSString)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        return [dragItem]
    }
    
    func collectionView(_ collectionView: UICollectionView, itemsForAddingTo session: UIDragSession, at indexPath: IndexPath, point: CGPoint) -> [UIDragItem] {
        let itemProvider = NSItemProvider(object: "\(indexPath.item)" as NSString)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        return [dragItem]
    }
}
