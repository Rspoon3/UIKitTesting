//
//  ViewController.swift
//  UIKitTesting
//
//  Created by Richard Witherspoon on 3/1/22.
//

import UIKit
import LoremSwiftum
//https://stackoverflow.com/questions/71918534/make-nscollectionlayoutitem-heights-as-tall-as-the-nscollectionlayoutgroup-when

class ViewController: UIViewController {
    let syncer = ContentOffsetSynchronizer()
    let sentences = [
        "This is a short sentence for a short string",
        "This week is WWDC and Im hoping that I can get some help with this long sentence so that it resizes properly. Maybe this should just be its own api? Idk I just need a long sentence for this to resize properly. Please be long enough now.",
        "I was able to mock this expected behavior by changing the NSCollectionLayoutSize to be an absolute value of 500. This is not what I want."
    ]
    
    enum Section {
        case main, table
    }
    
    var dataSource: UICollectionViewDiffableDataSource<Section, AnyHashable>! = nil
    var collectionView: UICollectionView! = nil
    let sectionBackgroundDecorationElementKind = "section-background-element-kind"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Two-Column Grid"
        configureHierarchy()
        configureDataSource()
    }
    
    /// - Tag: TwoColumn
    func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.2),
                                             heightDimension: .estimated(22))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .estimated(22))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,subitem: item, count: 1)
        let section = NSCollectionLayoutSection(group: group)        
        let layout = UICollectionViewCompositionalLayout(section: section)
        let config = UICollectionViewCompositionalLayoutConfiguration()
        layout.configuration = config
        return layout
    }
    
    func configureHierarchy() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .systemBackground
        view.addSubview(collectionView)
    }
    
    func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<ColumnsCell, String> { [weak self] (cell, indexPath, string) in
            // Populate the cell with our item description.
//            cell.configure(count: Int.random(in: 2..<5))
            self?.syncer.register(cell.scrollView)
            
        }
        
        let intRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, Int> { [weak self] (cell, indexPath, int) in
            var content = cell.defaultContentConfiguration()
            content.text = int.description
            cell.contentConfiguration = content
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, AnyHashable>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, item: AnyHashable) -> UICollectionViewCell? in
            if let string = item as? String{
                return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: string)
            } else if let int = item as? Int{
                return collectionView.dequeueConfiguredReusableCell(using: intRegistration, for: indexPath, item: int)
            } else {
                fatalError()
            }
        }
        
        // initial data
        var snapshot = NSDiffableDataSourceSnapshot<Section, AnyHashable>()
        snapshot.appendSections([.main])
        snapshot.appendItems(Array(0..<10))
        snapshot.appendItems(sentences)
        snapshot.appendItems(Array(10..<20))
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}


final class ContentOffsetSynchronizer : ObservableObject {
    private var observations: [NSKeyValueObservation] = []
    let registrations = NSHashTable<UIScrollView>.weakObjects()

    private var contentOffset: CGPoint = .zero {
        didSet {
            // Sync all scrollviews with to the new content offset
            for scrollView in registrations.allObjects where (scrollView.isDragging || scrollView.isDecelerating) == false {
                scrollView.contentOffset.x = contentOffset.x
            }
        }
    }

    func register(_ scrollView: UIScrollView) {
        scrollView.clipsToBounds = false

        guard registrations.contains(scrollView) == false else {
            return
        }

        registrations.add(scrollView)

        // When a user is interacting with the scrollView, we store its contentOffset
        observations.append(
            scrollView.observe(\.contentOffset, options: [.initial, .new]) { [weak self] scrollView, change in
                guard let newValue = change.newValue, (scrollView.isDragging || scrollView.isDecelerating) else {
                    return
                }
                self?.contentOffset = newValue
            }
        )
        
        // If a contentSize changes, we need to re-sync it with the current contentOffset
        observations.append(
            scrollView.observe(\.contentSize, options: [.initial, .new]) { [weak self] scrollView, change in
                guard let contentOffset = self?.contentOffset else {
                    return
                }
                scrollView.contentOffset.x = contentOffset.x
            }
        )
    }
    
    deinit {
        observations.forEach { $0.invalidate() }
    }
}
