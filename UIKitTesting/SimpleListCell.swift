//
//  SimpleListCell.swift
//  UIKitTesting
//
//  Created by Richard Witherspoon on 7/20/22.
//

import UIKit

//class SimpleListCell: UICollectionViewCell {
//    var dataSource: UICollectionViewDiffableDataSource<Section, String>! = nil
//    var collectionView: UICollectionView! = nil
//    var hasAppliedSnapshot = false
//
//    enum Section: String {
//        case main
//    }
//
//    //MARK: - Initializer
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//
//        configureHierarchy()
//        configureDataSource()
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//
//    //MARK: - Views
//    private func createLayout() -> UICollectionViewLayout {
//        return UICollectionViewCompositionalLayout() { [weak self] sectionIndex, layoutEnvironment in
//            var config = UICollectionLayoutListConfiguration(appearance: .plain)
//            config.headerMode = .supplementary
//            config.headerTopPadding = 0
//
//            let section = NSCollectionLayoutSection.list(using: config,
//                                                         layoutEnvironment: layoutEnvironment)
//
//
//            section.boundarySupplementaryItems.forEach({$0.pinToVisibleBounds = true })
//
//            return section
//        }
//    }
//
//
//    private func configureHierarchy() {
//        collectionView = UICollectionView(frame: contentView.bounds, collectionViewLayout: createLayout())
//        collectionView.translatesAutoresizingMaskIntoConstraints = false
//        collectionView.delegate = self
//        collectionView.dropDelegate = self
//        collectionView.dragDelegate = self
//        collectionView.dragInteractionEnabled = true
//        collectionView.layer.backgroundColor = UIColor.systemRed.cgColor
//        collectionView.alwaysBounceVertical = false
//        collectionView.backgroundColor = .red
//        collectionView.layer.masksToBounds = true
//        collectionView.layer.cornerRadius = 10
//        contentView.addSubview(collectionView)
//
//        let padding: CGFloat = 15
//        NSLayoutConstraint.activate([
//            collectionView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: padding),
//            collectionView.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant: -padding),
//            collectionView.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: padding),
//            collectionView.trailingAnchor.constraint(equalTo:  contentView.safeAreaLayoutGuide.trailingAnchor, constant: -padding),
//        ])
//    }
//
//    private func configureDataSource() {
//        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, String> { (cell, indexPath, item) in
//            var content = cell.defaultContentConfiguration()
//            content.text = item
//            let names = ["star", "pencil", "plus", "minus", "person", "trash", "paperclip"]
//            content.image = UIImage(systemName: names.randomElement()!)
//            cell.contentConfiguration = content
//        }
//
//        dataSource = UICollectionViewDiffableDataSource<Section, String>(collectionView: collectionView) {
//            (collectionView: UICollectionView, indexPath: IndexPath, identifier: String) -> UICollectionViewCell? in
//
//            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: identifier)
//        }
//
//
//        let headerRegistration = UICollectionView.SupplementaryRegistration
//        <TitleSupplementaryView>(elementKind: UICollectionView.elementKindSectionHeader) {
//            (supplementaryView, string, indexPath) in
//            supplementaryView.label.text = "Test (1)"
//            supplementaryView.backgroundColor = .systemBlue
//        }
//
//        dataSource.supplementaryViewProvider = { [weak self] (view, kind, index) in
//            guard let self = self else { return nil }
//            return self.collectionView.dequeueConfiguredReusableSupplementary(using:headerRegistration, for: index)
//        }
//    }
//
//    func applyInitialSnapshot() {
//        guard !hasAppliedSnapshot else { return }
//        hasAppliedSnapshot.toggle()
//
//        let items = Array(1...Int.random(in: 1...910)).map{"This is item \($0)"}
//        var snapshot = NSDiffableDataSourceSnapshot<Section, String>()
//        snapshot.appendSections([.main])
//
//        if Bool.random() {
//            snapshot.appendItems(items)
//        }
//
//        dataSource.apply(snapshot, animatingDifferences: false)
//    }
//}
//
//
//extension SimpleListCell: UICollectionViewDelegate {
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        collectionView.deselectItem(at: indexPath, animated: false)
//    }
//}
//
//extension SimpleListCell: UICollectionViewDropDelegate {
//    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
//
//    }
//
//    func collectionView(_ collectionView: UICollectionView, dropSessionDidEnter session: UIDropSession) {
//        collectionView.layer.borderWidth = 2
//    }
//
//    func collectionView(_ collectionView: UICollectionView, dropSessionDidExit session: UIDropSession) {
//        collectionView.layer.borderWidth = 0
//    }
//
//    func collectionView(_ collectionView: UICollectionView, dropSessionDidEnd session: UIDropSession) {
//        collectionView.layer.borderWidth = 0
//    }
//
//    func collectionView(_ collectionView: UICollectionView, canHandle session: UIDropSession) -> Bool {
//        !collectionView.hasActiveDrag
//    }
//}
//
//
//extension SimpleListCell: UICollectionViewDragDelegate {
//    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
//        let itemProvider = NSItemProvider(object: "\(indexPath.item)" as NSString)
//        let dragItem = UIDragItem(itemProvider: itemProvider)
//        return [dragItem]
//    }
//}
//
//
//class TitleSupplementaryView: UICollectionReusableView {
//    let label = UILabel()
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        configure()
//    }
//    required init?(coder: NSCoder) {
//        fatalError()
//    }
//
//    func configure() {
//        addSubview(label)
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.adjustsFontForContentSizeCategory = true
//        let inset = CGFloat(10)
//        NSLayoutConstraint.activate([
//            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: inset),
//            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -inset),
//            label.topAnchor.constraint(equalTo: topAnchor, constant: inset),
//            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -inset)
//        ])
//        label.font = UIFont.preferredFont(forTextStyle: .title3)
//    }
//}




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
        
        if numberLabel.frame.height > numberLabel.frame.width {
            numberLabel.widthAnchor.constraint(equalToConstant: numberLabel.frame.height).isActive = true
        }
        
        numberLabel.layer.cornerRadius = numberLabel.frame.height / 2

//        print("laying out \(numberLabel.text)", numberLabel.frame.height)
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
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, String> { (cell, indexPath, item) in
            var content = cell.defaultContentConfiguration()
            content.text = item
            let names = ["star", "pencil", "plus", "minus", "person", "trash", "paperclip"]
            content.image = UIImage(systemName: names.randomElement()!)

            let button = UIButton()
            let action1 = UIAction(title: "Test 1"){_ in }
            let action2 = UIAction(title: "Test 1"){_ in }
            let action3 = UIAction(title: "Test 1"){_ in }
            button.menu = .init(title: "", children: [action1, action2, action3])
            button.showsMenuAsPrimaryAction = true
            button.setImage(UIImage(systemName: "pencil"), for: .normal)

            let test = UICellAccessory.CustomViewConfiguration(customView: button, placement: .trailing(), tintColor: .secondaryLabel)
            cell.accessories = [.customView(configuration: test)]
            cell.contentConfiguration = content
        }

        dataSource = UICollectionViewDiffableDataSource<Section, String>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, identifier: String) -> UICollectionViewCell? in

            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: identifier)
        }
    }

    func applyInitialSnapshot() {
        guard !hasAppliedSnapshot else { return }
        hasAppliedSnapshot.toggle()

        let items = Array(1...Int.random(in: 1...910)).map{"This is item \($0)"}
        var snapshot = NSDiffableDataSourceSnapshot<Section, String>()
        snapshot.appendSections([.main])
        
        if Bool.random() {
            snapshot.appendItems(items)
            numberLabel.text = items.count.description
        } else {
            numberLabel.text = "0"
        }
        
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

class PaddedLabel: UILabel {
    let topInset:    CGFloat
    let bottomInset: CGFloat
    let leftInset:   CGFloat
    let rightInset:  CGFloat
    
    init(padding: CGFloat) {
        topInset    = padding
        bottomInset = padding
        leftInset   = padding
        rightInset  = padding
        super.init(frame: .zero)
    }
    
    init(top: CGFloat, bottom: CGFloat, left: CGFloat, right: CGFloat) {
        topInset    = top
        bottomInset = bottom
        leftInset   = left
        rightInset  = right
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets.init(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: rect.inset(by: insets))
    }
    
    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + leftInset + rightInset,
                      height: size.height + topInset + bottomInset)
    }
}
