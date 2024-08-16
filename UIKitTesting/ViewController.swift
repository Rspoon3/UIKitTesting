//
//  ViewController.swift
//  UIKitTesting
//
//  Created by Richard Witherspoon on 3/1/22.
//

import UIKit

final class ViewController: UIViewController {
    private var dataSource: UICollectionViewDiffableDataSource<Section, String>! = nil
    private var collectionView: UICollectionView! = nil
    private let items = Array(0..<4).map{$0.formatted()}
    let collectionViewLayout = UICollectionViewFlowLayout()
    var centers: [Double] = [0]
    private var cellWidth: CGFloat = 0
    private var cellHeight: CGFloat = 0
    private let minimumLineSpacing: CGFloat = 12
    private var currentIndex = 0
    private let insets: CGFloat = 12

    enum Section: String {
        case main
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Grid"
        configureCollectionViewLayout()
        configureCollectionView()
        configureDataSource()
        applyInitialSnapshot()
    }
    
    private func configureCollectionViewLayout() {
        cellWidth = (UIScreen.main.bounds.width * 0.7)
        cellHeight = cellWidth / 2
        
        let halfOfCellWidth = cellWidth / 2
        let halfOfScreenWidth = UIScreen.main.bounds.width / 2
        
        let firstCellCenterX = halfOfScreenWidth - halfOfCellWidth
        
        let distanceBetweenCenterOfCells = cellWidth + minimumLineSpacing
        let centerOfSecondCell = distanceBetweenCenterOfCells - firstCellCenterX + insets
        
        centers.append(centerOfSecondCell)
        
        for _ in 0..<items.count - 1 {
            centers.append(centers.last! + distanceBetweenCenterOfCells)
        }
        
        collectionViewLayout.sectionInset = .init(top: 0, left: insets, bottom: 0, right: insets)
        collectionViewLayout.minimumLineSpacing = minimumLineSpacing
        collectionViewLayout.scrollDirection = .horizontal
        collectionViewLayout.itemSize = .init(
            width: cellWidth,
            height: cellHeight
        )
    }
    
    private func configureCollectionView() {
//        let layout = PagingCollectionViewFlowLayout(itemsCount: items.count)
//        collectionViewLayout.configure()
        
        collectionView = UICollectionView(
            frame: view.bounds,
            collectionViewLayout: collectionViewLayout
        )
        collectionView.backgroundColor = .systemBackground
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.decelerationRate = .fast
        
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: cellHeight),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<TextCell, String> { (cell, indexPath, item) in
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
}


extension ViewController: UICollectionViewDelegate {
    
    func scrollViewWillEndDragging(
        _ scrollView: UIScrollView,
        withVelocity velocity: CGPoint,
        targetContentOffset: UnsafeMutablePointer<CGPoint>
    ) {
        let closest = centers.closest(to: targetContentOffset.pointee.x)
        let x: CGFloat
        
        if velocity.x == 0 {
            x = closest ?? 0
        } else if velocity.x > 0 {
            x = centers.first(where: {$0 > targetContentOffset.pointee.x}) ?? 0
        } else {
            x = centers.last(where: {$0 < targetContentOffset.pointee.x}) ?? 0
        }
        
        let point = CGPoint(
            x: x,
            y: targetContentOffset.pointee.y
        )
        
        targetContentOffset.pointee = point
        currentIndex = centers.firstIndex(where: {$0 == x}) ?? 0
    }
}

// right blue visible
// (393 - 287.1) = 105.9 blue visible
// 196.5 - 105.9 = 90.6 not visible

// 287.1 - 58.95 = 228.15 // 1st!


// Center to center = (137.55.5 * 2) + 12 = 287.1

// first off center = 196.5 - 137.55 = 58.95



// 393, 196.5
// (393 * 0.7) = 275.1 / 2 = 137.55 / 2 = 68.775

// 275.1 + 12 = 287.1

// 68.775 * 2 + 12 = 149.55 + 137.55 = 287.1
// 12



// 196.5 + 12 = 208.5

// 208.5 + 24 = 232.5

final class TextCell: UICollectionViewCell {
    let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("not implemented")
    }
    
    private func configure() {
        let blue = UIView()
        blue.backgroundColor = .systemBlue
        
        let red = UIView()
        red.backgroundColor = .systemRed
        
        let stack = UIStackView(arrangedSubviews: [blue, red])
        stack.axis = .horizontal
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = 0
        stack.distribution = .fillEqually
        
        contentView.addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: contentView.topAnchor),
            stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
        
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .largeTitle, compatibleWith: nil)
        contentView.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: contentView.topAnchor),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
}


#Preview {
    ViewController()
}

extension Collection where Element: Comparable & SignedNumeric {
    func closest(to target: Element) -> Element? {
        guard !isEmpty else { return nil }
        
        var closest = self[startIndex]
        for number in self {
            if abs(number - target) < abs(closest - target) {
                closest = number
            }
        }
        return closest
    }
}


final class SimpleGrid: UIViewController {
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
        view.addSubview(collectionView)
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
}


extension UICollectionView.CellRegistration {
    static func demo() -> UICollectionView.CellRegistration<TextCell, String> {
        let cellRegistration = UICollectionView.CellRegistration<TextCell, String> { (cell, indexPath, item) in
            cell.contentView.backgroundColor = .systemBlue
            cell.label.text = item
            cell.label.textColor = .white
        }
        return cellRegistration
    }
}
