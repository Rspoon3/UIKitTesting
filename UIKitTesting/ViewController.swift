//
//  ViewController.swift
//  UIKitTesting
//
//  Created by Richard Witherspoon on 3/1/22.
//

import UIKit
import LoremSwiftum
import Combine

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    var cellRegistration: UICollectionView.CellRegistration<TestCell, UIColor>!
    var textCellRegistration: UICollectionView.CellRegistration<UICollectionViewListCell, String>!
    var collectionView: UICollectionView! = nil
    let minScale: CGFloat = 0.8
    let maxScale: CGFloat = 1
    let carouselItems = [UIColor.systemRed, .systemBlue, .systemOrange, .systemPink, .systemGray, .systemTeal, .systemGreen]
    let listItems = Array(0..<100).map{_ in Lorem.sentences(.random(in: 1..<5))}
    var currentIndex: IndexPath!
    let scrollRateInSeconds: TimeInterval = 3
    private let numberOfCarouselItems = 1_000_000
    private var cancellables = Set<AnyCancellable>()
    private var scrollViewObserver: ScrollViewObserver?
    
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "List"
        configureCollectionView()
        scrollToMiddle()
//        startTimer()
        
        
        UIScrollView.swizzlScrollViewWillBeginDragging()
        
        if let scrollView = collectionView.horizontalUIScrollViews().first {
            scrollViewObserver = ScrollViewObserver(scrollView: scrollView)
        }
    }
    
    
    //MARK: - Private Helpers
    
    private func scrollToMiddle() {
        currentIndex = IndexPath(row: carouselItems.count / 2, section: 0)
        collectionView.scrollToItem(at: currentIndex, at: .centeredHorizontally, animated: false)
    }
    
    private func startTimer() {
        let _ = Timer.scheduledTimer(withTimeInterval: scrollRateInSeconds, repeats: true) { [weak self] timer in
            guard let self else { return }
            var animated = true
            
            if self.currentIndex.item == self.carouselItems.count {
                self.currentIndex.item = 0
                animated = false
            }
            
            self.collectionView.scrollToItem(at: self.currentIndex, at: .centeredHorizontally, animated: animated)
            self.currentIndex.item += 1
        }
    }
    
    
    //MARK: - Layout
    
    private func createCarasouelSection(_ layoutEnvironment: NSCollectionLayoutEnvironment, _ self: ViewController) -> NSCollectionLayoutSection? {
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
            //            print(items.first?.indexPath, items.last?.indexPath)
            
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
    
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self]
            (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            guard let self else { return nil }
            
            if sectionIndex == 0 {
                return self.createCarasouelSection(layoutEnvironment, self)
            } else {
                let config = UICollectionLayoutListConfiguration(appearance: .plain)
                return .list(using: config, layoutEnvironment: layoutEnvironment)
            }
        }
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 20
        layout.configuration = config
        return layout
    }
    
    private func configureCollectionView() {
        cellRegistration = UICollectionView.CellRegistration<TestCell, UIColor> { (cell, indexPath, color) in
            cell.configure(with: color)
        }
        
        textCellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, String> { (cell, indexPath, text) in
            var content = cell.defaultContentConfiguration()
            content.text = text
            cell.contentConfiguration = content
        }
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        collectionView.dataSource = self
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    
    //MARK: - Data Source
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let index = indexPath.item % carouselItems.count
            let item = carouselItems[index]
            
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
        } else {
            let item = listItems[indexPath.item]
            return collectionView.dequeueConfiguredReusableCell(using: textCellRegistration, for: indexPath, item: item)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return numberOfCarouselItems
        } else {
            return listItems.count
        }
    }
    
    
    //MARK: - Delegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: false)
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return false
    }
}
