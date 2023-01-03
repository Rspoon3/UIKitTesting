//
//  CarouselVC.swift
//  UIKitTesting
//
//  Created by Richard Witherspoon on 12/31/22.
//

import UIKit

class CarouselVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    let collectionViewOpacity: Float = 0.5
    var collectionView: UICollectionView! = nil
    var cellRegistration: UICollectionView.CellRegistration<CarouselCell, UIColor>!
    let carouselItems = [UIColor.systemRed, .systemBlue, .systemOrange, .systemPink, .systemGray, .systemTeal, .systemGreen]
    let scrollRateInSeconds: TimeInterval = 4
    var timer: Timer?
    let numberOfCarouselItems = 1_000_000
    var currentIndex: IndexPath!
    
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let stack = ColorStackView()
        stack.addAndConstraint(to: view)
        
        registerCell()
        configureCollectionView()
//        scrollToMiddle()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer?.invalidate()
        timer = nil
    }

    // MARK: - Public Helper
    
    func scrollToMiddle() {
        currentIndex = IndexPath(row: numberOfCarouselItems / 2, section: 0)
        collectionView.scrollToItem(at: currentIndex, at: .centeredHorizontally, animated: true)
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    func configureCollectionView() {
        fatalError("\(#function) has not be implmented")
    }
    
    func commonCollectionViewSetup() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.decelerationRate = .fast
        collectionView.layer.opacity = collectionViewOpacity
        
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    // MARK: - Private Helper
    
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
    
    private func registerCell() {
        cellRegistration = UICollectionView.CellRegistration<CarouselCell, UIColor> { (cell, indexPath, color) in
            cell.configure(with: color, indexPath: indexPath)
        }
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

