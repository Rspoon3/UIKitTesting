//
//  ViewController.swift
//  UIKitTesting
//
//  Created by Richard Witherspoon on 3/1/22.
//

import UIKit

class ViewController: UIViewController {
    var dataSource: UICollectionViewDiffableDataSource<Section, String>! = nil
    var collectionView: UICollectionView! = nil
    var items = Array(0..<4).map{"This is item \($0)"}
    let pageControl = UIPageControl()

    enum Section: String {
        case main
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "List"
        view.backgroundColor = .systemGroupedBackground
        configureHierarchy()
        configureDataSource()
        applyInitialSnapshot()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        pageControl.isHidden = traitCollection.horizontalSizeClass != .compact
    }
        
    private func createLayout() -> UICollectionViewLayout {
        let sectionProvider = { [weak self] (sectionIndex: Int,
                                 layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            let isCompact = self?.traitCollection.horizontalSizeClass == .compact
            let height: CGFloat = 1
            let maxWidth: CGFloat = 450
            let minWidth: CGFloat = 300
            let spacing: CGFloat = 10
            let quarterSize = layoutEnvironment.container.effectiveContentSize.width / 4.0
            var isFlexible: Bool
            var itemWidth: NSCollectionLayoutDimension!
            var groupWidth: NSCollectionLayoutDimension!

            if minWidth < quarterSize {
                itemWidth = .fractionalWidth(1 / 4)
                groupWidth = .fractionalWidth(1)
                isFlexible = true
            } else {
                itemWidth = .absolute(maxWidth)
                groupWidth = .absolute(maxWidth * 4)
                isFlexible = false
            }
            
            
            let itemSize = NSCollectionLayoutSize(widthDimension: isCompact ? .fractionalWidth(1) : itemWidth,
                                                  heightDimension: .fractionalHeight(height))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = .init(top: 0,
                                       leading: isCompact ? spacing * 2 : spacing,
                                       bottom: 0,
                                       trailing: isCompact ? spacing * 2 : spacing)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: isCompact ? .fractionalWidth(1) : groupWidth,
                                                   heightDimension: .fractionalHeight(height))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            
            if isFlexible && !isCompact {
                group.contentInsets = .init(top: 0, leading: spacing, bottom: 0, trailing: spacing)
            }
            
            
            let section = NSCollectionLayoutSection(group: group)
            
            if !isFlexible && !isCompact {
                section.contentInsets = .init(top: 0, leading: spacing, bottom: 0, trailing: spacing)
            }
            
            section.orthogonalScrollingBehavior = isCompact ? .groupPaging : .continuous
            section.visibleItemsInvalidationHandler = { [weak self] visibleItems, point, environment in
                guard
                    let self = self,
                    let last = visibleItems.last
                else {
                    return
                }
                self.pageControl.currentPage = last.indexPath.item
            }
            
            
            return section
        }
        
        return UICollectionViewCompositionalLayout(sectionProvider: sectionProvider)
    }
    
    private func configureHierarchy() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.backgroundColor = .systemGroupedBackground
        collectionView.alwaysBounceVertical = false
        
        pageControl.pageIndicatorTintColor = .gray
        pageControl.currentPageIndicatorTintColor = .red
        pageControl.numberOfPages = 4
        pageControl.backgroundColor = .systemGroupedBackground
        pageControl.isHidden = traitCollection.horizontalSizeClass != .compact
        pageControl.addTarget(self, action: #selector(pageControlTapHandler(sender:)), for: .valueChanged)

        let stack = UIStackView(arrangedSubviews: [collectionView, pageControl])
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.backgroundColor = .systemGroupedBackground

        view.addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            stack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo:  view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    @objc func pageControlTapHandler(sender:UIPageControl) {
        collectionView.scrollToItem(at: .init(row: sender.currentPage, section: 0),
                                    at: .top, animated: true)
    }
    
    private func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<SimpleListCell, String> { (cell, indexPath, item) in
            cell.applyInitialSnapshot()
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, String>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, identifier: String) -> UICollectionViewCell? in
            
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
