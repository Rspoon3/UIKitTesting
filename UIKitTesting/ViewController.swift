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
    var collectionView: OrthogonalUICollectionView! = nil
    let minScale: CGFloat = 0.8
    let maxScale: CGFloat = 1
    let carouselItems = [UIColor.systemRed, .systemBlue, .systemOrange, .systemPink, .systemGray, .systemTeal, .systemGreen]
    var currentIndex: IndexPath!
    let scrollRateInSeconds: TimeInterval = 4
    private let numberOfCarouselItems = 1_000_000
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
        //        startTimer()
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
    
    
//    func createLayout() -> UICollectionViewLayout {
//        let columns = 3
//        let spacing = CGFloat(10)
//
//        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
//                                              heightDimension: .estimated(100))
//        let item = NSCollectionLayoutItem(layoutSize: itemSize)
//
//        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
//                                               heightDimension: .estimated(100))
//        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: columns)
//        group.interItemSpacing = .fixed(spacing)
//
//        let section = NSCollectionLayoutSection(group: group)
//        section.interGroupSpacing = spacing
//        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
//
//        return EqualHeightsUICollectionViewCompositionalLayout(section: section, columns: columns)
//    }
    
    private func createLayout() -> UICollectionViewLayout {
        
        
        return CustomLayout { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
        
//        return UICollectionViewCompositionalLayout { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            
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
            let section = NSCollectionLayoutSection(group: group)
            
            section.orthogonalScrollingBehavior = .groupPagingCentered
            section.interGroupSpacing = 12
            
            return section
//            return section
        }
    }
    
    private func configureCollectionView() {
        cellRegistration = UICollectionView.CellRegistration<TestCell, UIColor> { (cell, indexPath, color) in
            cell.configure(with: color, indexPath: indexPath)
            cell.label.text = indexPath.item.formatted()
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
        let index = indexPath.item % carouselItems.count
        let item = carouselItems[index]
        
        return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfCarouselItems
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


