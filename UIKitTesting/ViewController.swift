//
//  ViewController.swift
//  UIKitTesting
//
//  Created by Richard Witherspoon on 3/1/22.
//

import UIKit
import LoremSwiftum

class ViewController: UIViewController {
    var dataSource: UICollectionViewDiffableDataSource<Section, String>! = nil
    var collectionView: UICollectionView! = nil
    var items = Array(1...6).map{"\($0) \(Lorem.words(Int.random(in: 10...100)))"}
    var itemsTwo = Array(1...14).map{"\($0) \(Lorem.words(Int.random(in: 10...100)))"}
    var itemsThree = Array(1...7).map{"\($0) \(Lorem.words(Int.random(in: 10...100)))"}

    enum Section: String {
        case main, two, three
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "List"
        configureCollectionView()
        configureDataSource()
        applyInitialSnapshot()
    }
    
    
    private func configureCollectionView() {
        let layout = MosaicLayout()
//        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .systemBackground
        view.addSubview(collectionView)
    }
    
    private func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<TextCell, String> { (cell, indexPath, item) in
            cell.configure(text: item)
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, String>(collectionView: collectionView) {
            (collectionView, indexPath, identifier) -> UICollectionViewCell? in
            
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: identifier)
        }
    }
    
    private func applyInitialSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, String>()
        snapshot.appendSections([.main, .two])
        snapshot.appendItems(items, toSection: .main)
        snapshot.appendItems(itemsTwo, toSection: .two)
        
        snapshot.appendSections([.three])
        snapshot.appendItems(itemsThree, toSection: .three)

        dataSource.apply(snapshot, animatingDifferences: false)
    }
}

class MosaicLayout: UICollectionViewFlowLayout {

    var contentBounds = CGRect.zero
    var cachedAttributes = [Int: [UICollectionViewLayoutAttributes]]()
    
    /// - Tag: PrepareMosaicLayout
    override func prepare() {
        super.prepare()
        
        guard let collectionView = collectionView else { return }
        let numberOfSections = collectionView.numberOfSections
        let cvWidth = collectionView.bounds.size.width
        let padding: CGFloat = 10

        cachedAttributes.removeAll()
        contentBounds = CGRect(origin: .zero, size: collectionView.bounds.size)
        
        for section in 0..<numberOfSections {
            let itemCount = collectionView.numberOfItems(inSection: section)
            
            var lastFrame: CGRect = .zero
            
            cachedAttributes[section] = []
            
            for currentIndex in 0..<itemCount {
                var x: CGFloat = 0
                
                if section > 0 {
                    x = (cvWidth / CGFloat(numberOfSections)) * CGFloat(section)
                }
                
                                
                let segmentFrame = CGRect(x: x,
                                          y: lastFrame.maxY + padding,
                                          width: (cvWidth / CGFloat(numberOfSections)) - padding,
                                          height: section == 0 ? 200 : 300 * CGFloat(section))
                
                let attributes = UICollectionViewLayoutAttributes(forCellWith: IndexPath(item: currentIndex, section: section))
                attributes.frame = segmentFrame
                
                cachedAttributes[section]?.append(attributes)
                contentBounds.size.height = max(contentBounds.size.height, segmentFrame.maxY + padding)
                
                lastFrame = segmentFrame
            }
        }
    }

    override var collectionViewContentSize: CGSize {
        return contentBounds.size
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        guard let collectionView = collectionView else { return false }
        return !newBounds.size.equalTo(collectionView.bounds.size)
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cachedAttributes[indexPath.section]?[indexPath.item]
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let allCachedAttributes = cachedAttributes.flatMap(\.value)
        
        return allCachedAttributes.filter{rect.intersects($0.frame) }
    }
}


class TextCell: UICollectionViewCell {
    private let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBlue.withAlphaComponent(0.75)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("not implemented")
    }

    
    
    func configure(text: String) {
        label.text = text
        
        print("Got text")
    }
    
    private func configure() {
        let bottomLabel = UILabel()
        
        label.numberOfLines = 0
        label.font = UIFont.preferredFont(forTextStyle: .title1)
        label.backgroundColor = .systemPurple
        label.textColor = .white
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        
        bottomLabel.numberOfLines = 0
        bottomLabel.font = UIFont.preferredFont(forTextStyle: .title1)
        bottomLabel.text = "Bottom of cell"
        bottomLabel.backgroundColor = .systemRed
        bottomLabel.textColor = .white
        bottomLabel.setContentHuggingPriority(.defaultLow, for: .vertical)
        
        let stackView = UIStackView(arrangedSubviews: [label, bottomLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 20

        contentView.addSubview(stackView)
        
        let padding: CGFloat = 15
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            stackView.trailingAnchor.constraint(equalTo:  contentView.trailingAnchor, constant: -padding),
        ])
    }
}

extension UIColor {
    static func random(alpha: CGFloat = 1.0) -> UIColor {
        let r = CGFloat.random(in: 0...1)
        let g = CGFloat.random(in: 0...1)
        let b = CGFloat.random(in: 0...1)
        
        return UIColor(red: r, green: g, blue: b, alpha: alpha)
    }
    
    static var lightRandom: UIColor {
        random(alpha: 0.3)
    }
}

