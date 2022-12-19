//
//  ViewController.swift
//  UIKitTesting
//
//  Created by Richard Witherspoon on 3/1/22.
//

import UIKit

struct ColorItem: Identifiable, Hashable {
    let id: UUID = UUID()
    let color: UIColor
}

class ViewController: UIViewController {
    var dataSource: UICollectionViewDiffableDataSource<Section, ColorItem>! = nil
    var collectionView: UICollectionView! = nil
    let minScale: CGFloat = 0.8
    let maxScale: CGFloat = 1
    var items = [ColorItem]()
    var currentIndex: IndexPath!
    let scrollRateInSeconds: TimeInterval = 3
    private var canPrint = false


    enum Section: String {
        case main
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "List"

        for _ in 0..<1_000{
            let colors = [UIColor.systemRed, .systemBlue, .systemOrange, .systemPink, .systemGray, .systemTeal, .systemGreen].map{ColorItem(color: $0)}
            items.append(contentsOf: colors)
        }

        configureCollectionView()
        configureDataSource()
        applyInitialSnapshot()
        scrollToMiddle()
//        startTimer()
        
        canPrint = true
    }

    private func scrollToMiddle() {
        currentIndex = IndexPath(row: items.count / 2, section: 0)
        collectionView.scrollToItem(at: currentIndex, at: .centeredHorizontally, animated: false)
    }

    private func startTimer() {
        let _ = Timer.scheduledTimer(withTimeInterval: scrollRateInSeconds, repeats: true) { [weak self] timer in
            guard let self else { return }
            var animated = true

            if self.currentIndex.item == self.items.count {
                self.currentIndex.item = 0
                animated = false
            }

            self.collectionView.scrollToItem(at: self.currentIndex, at: .centeredHorizontally, animated: animated)
            self.currentIndex.item += 1
        }
    }

    func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { [weak self]
            (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            guard let self else { return nil }
            let containerWidth = layoutEnvironment.container.contentSize.width
            let spacing: CGFloat = 12
            let width: CGFloat = containerWidth - spacing * 4
            let heightFraction: CGFloat  =  160 / 327

            // Item
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                  heightDimension: .fractionalHeight(1))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)

            // Group
            let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(width),
                                                   heightDimension: .fractionalWidth(heightFraction))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

            // Section
            let interGroupSpacing = -(width - (width * self.minScale)) / 2
            let section = NSCollectionLayoutSection(group: group)

            section.orthogonalScrollingBehavior = .groupPagingCentered
            section.interGroupSpacing = interGroupSpacing + spacing

            section.visibleItemsInvalidationHandler = { [weak self] (items, offset, environment) in
                guard let self else { return }

                items.forEach { item in
                    guard let cell = self.collectionView.cellForItem(at: item.indexPath) as? TestCell else { return }

                    let distanceFromCenter = abs((item.frame.midX - offset.x) - environment.container.contentSize.width / 2.0)
                    let percentageToMidX =  1 - (distanceFromCenter / (item.frame.width + spacing))
                    let scale = ((self.maxScale - self.minScale) * percentageToMidX) + self.minScale
                    let clampedScale = max(self.minScale, scale)

                    cell.shadowOpacity(percentage: percentageToMidX)
                    item.transform = CGAffineTransform(scaleX: clampedScale, y: clampedScale)
                }
            }

            return section
        }
    }


    private func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        view.addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    private func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<TestCell, ColorItem> { (cell, indexPath, item) in
            cell.configure(with: item.color)
        }

        dataSource = UICollectionViewDiffableDataSource<Section, ColorItem>(collectionView: collectionView) {
            (collectionView, indexPath, item) -> UICollectionViewCell? in

            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
        }
    }

    private func applyInitialSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, ColorItem>()
        snapshot.appendSections([.main])
        snapshot.appendItems(items)

        dataSource.apply(snapshot, animatingDifferences: false)
    }
}

extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if isViewLoaded {
            print("Did end", indexPath.item)
        }
    }
}
