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
    var collectionView: OrthogonalUICollectionView! = nil
    let minScale: CGFloat = 0.8
    let maxScale: CGFloat = 1
    let carouselItems = [UIColor.systemRed, .systemBlue, .systemOrange, .systemPink, .systemGray, .systemTeal, .systemGreen]
    let listItems = Array(0..<100).map{_ in Lorem.sentences(.random(in: 1..<5))}
    var currentIndex: IndexPath!
    let scrollRateInSeconds: TimeInterval = 4
    private let numberOfCarouselItems = 1_000_000
    private var cancellables = Set<AnyCancellable>()
    private var scrollViewObserver: ScrollViewObserver?
    private var timer: Timer?
    
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "List"
        configureCollectionView()
        scrollToMiddle()
    }
    
    //MARK: - Private Helpers
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startTimer()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer?.invalidate()
        timer = nil
    }
    
    private func scrollToMiddle() {
        currentIndex = IndexPath(row: numberOfCarouselItems / 2, section: 0)
        collectionView.scrollToItem(at: currentIndex, at: .centeredHorizontally, animated: true)
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: scrollRateInSeconds, repeats: true) { [weak self] timer in
            self?.scrollToNextIndex()
        }
    }
    
    private func scrollToNextIndex() {
        if currentIndex.item == numberOfCarouselItems - 1 {
            currentIndex.item = 0
        } else {
            currentIndex.item += 1
        }
        
        collectionView.scrollToItem(at: currentIndex, at: .centeredVertically, animated: true)
    }
    
    
    //MARK: - Layout
    
    private func createCarasouelSection(_ layoutEnvironment: NSCollectionLayoutEnvironment, _ self: ViewController) -> NSCollectionLayoutSection? {
        let containerWidth = layoutEnvironment.container.contentSize.width
        let spacing: CGFloat = 12
        let width: CGFloat = containerWidth - spacing * 4
        
        // Item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        // Group
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(width),
                                               heightDimension: .absolute(width / 2))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        // Section
        let interGroupSpacing = -(width - (width * self.minScale)) / 2
        let section = NSCollectionLayoutSection(group: group)
        
        section.orthogonalScrollingBehavior = .groupPagingCentered
        section.interGroupSpacing = interGroupSpacing + spacing
        
        section.visibleItemsInvalidationHandler = { [weak self] (items, offset, environment) in
            guard let self else { return }
            
            items.forEach { item in
                let distanceFromCenter = abs((item.frame.midX - offset.x) - environment.container.contentSize.width / 2.0)
                let percentageToMidX =  1 - (distanceFromCenter / (item.frame.width + spacing))
                let scale = ((self.maxScale - self.minScale) * percentageToMidX) + self.minScale
                let clampedScale = max(self.minScale, scale)
                
                
                if let cell = self.collectionView.cellForItem(at: item.indexPath) as? TestCell {
                    cell.shadowOpacity(percentage: percentageToMidX)
//                    cell.scale(clampedScale)
                }
                
                item.transform = CGAffineTransform(scaleX: clampedScale, y: clampedScale)
                
                if scale > 0.9 {
                    self.currentIndex = item.indexPath
                }
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
            cell.configure(with: color, indexPath: indexPath)
            cell.label.text = indexPath.item.formatted()
        }
        
        textCellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, String> { (cell, indexPath, text) in
            var content = cell.defaultContentConfiguration()
            content.text = text
            cell.contentConfiguration = content
        }
        
        collectionView = OrthogonalUICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
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
        return 1
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: false)
        
        let test = UIViewController()
        test.view.backgroundColor = .red
        
        navigationController?.pushViewController(test, animated: true)
    }
    
    
    //MARK: - Delegate
    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        collectionView.deselectItem(at: indexPath, animated: false)
//    }
//
//    func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
//        return false
//    }
}
