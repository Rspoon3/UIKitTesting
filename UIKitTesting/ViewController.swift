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
    private var items = Array(0..<4).map{$0.formatted()}
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
        applySnapshot(of: items)
    }
    
    private func configureCollectionViewLayout() {
        cellWidth = (UIScreen.main.bounds.width * 0.7)
        cellHeight = cellWidth / 2
        collectionViewLayout.sectionInset = .init(top: 0, left: insets, bottom: 0, right: insets)
        collectionViewLayout.minimumLineSpacing = minimumLineSpacing
        collectionViewLayout.scrollDirection = .horizontal
        collectionViewLayout.itemSize = .init(
            width: cellWidth,
            height: cellHeight
        )
    }
    
    private func recalculateCenters(itemsCount: Int) {
        let halfOfCellWidth = cellWidth / 2
        let halfOfScreenWidth = UIScreen.main.bounds.width / 2
        let firstCellCenterX = halfOfScreenWidth - halfOfCellWidth
        let distanceBetweenCenterOfCells = cellWidth + minimumLineSpacing
        let centerOfSecondCell = distanceBetweenCenterOfCells - firstCellCenterX + insets
        
        centers = [0, centerOfSecondCell]
        
        for _ in 0..<itemsCount - 1 {
            guard let last = centers.last else { continue }
            centers.append(last + distanceBetweenCenterOfCells)
        }
    }
    
    private func configureCollectionView() {
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
    
    private func applySnapshot(of items: [String]) {
        recalculateCenters(itemsCount: items.count)

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


#Preview {
    ViewController()
}
