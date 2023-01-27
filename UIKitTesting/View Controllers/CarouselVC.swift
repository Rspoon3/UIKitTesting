//
//  CarouselVC.swift
//  UIKitTesting
//
//  Created by Richard Witherspoon on 12/31/22.
//

import UIKit
import SwiftUI

class CarouselVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    var collectionView: UICollectionView! = nil
    var currentIndex = IndexPath(item: 0, section: 0)
    private var cellRegistration: UICollectionView.CellRegistration<CarouselCell, String>!
    private var swiftUICellRegistration: UICollectionView.CellRegistration<UICollectionViewCell, String>!
    private var swiftUILegacyCellRegistration: UICollectionView.CellRegistration<SwiftUICollectionViewCell<CarouselCellView>, String>!
    private let carouselItems = Array(1...12).map{ i in "Slide-\(i)"}
    private var scrollRateInSeconds: TimeInterval?
    private var timer: Timer?
    private let numberOfCarouselItems = 100_000
    private var cellType: CellType = .uikit
    private let cellTypeButton = UIButton()
    private var showGif = true
    private var showCellType = true
    private var shouldScrollToMiddleForiOS14Bug = true
    private var viewDidAppear = false

    
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        registerCell()
        configureCollectionView()

        startTimer(timeInterval: 3)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if !viewDidAppear {
            scrollToMiddle()
        }
        
        
//        if #unavailable(iOS 15) {
//            guard shouldScrollToMiddleForiOS14Bug, isViewLoaded else { return }
//            scrollToMiddle()
//            shouldScrollToMiddleForiOS14Bug = false
//        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewDidAppear = true
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer?.invalidate()
        timer = nil
    }

    // MARK: - Public Helper
    
    func scrollToMiddle() {
        currentIndex = IndexPath(row: numberOfCarouselItems / 2, section: 0)
        collectionView.scrollToItem(at: .init(item: currentIndex.item, section: 0), at: .centeredHorizontally, animated: false)
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    func configureCollectionView() {
        fatalError("\(#function) has not be implmented")
    }
        
    func commonViewSetup() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.decelerationRate = .fast
        
        print(collectionView.decelerationRate.rawValue)
        
        let deceleartionLabel = UILabel()
        deceleartionLabel.text = "Deceleration Rate: normal"
        
        let deceleartionSwitch = UISwitch(frame: .zero, primaryAction: .init(handler: { [weak self] action in
            let mySwitch = action.sender as! UISwitch
            self?.collectionView.decelerationRate = mySwitch.isOn ? .normal : .fast
            
            deceleartionLabel.text = "Deceleration Rate: \(mySwitch.isOn ? "fast" : "normal")"
        }))
        
        deceleartionSwitch.isOn = true
        
        let decelerationStack = UIStackView(arrangedSubviews: [deceleartionLabel, deceleartionSwitch])
        decelerationStack.spacing = 10
        
        
        let typeLabel = UILabel()
        typeLabel.text = "Show Cell Type: \(showCellType)"
        
        let typeSwitch = UISwitch(frame: .zero, primaryAction: .init(handler: { [weak self] action in
            guard let self else { return }
            self.showCellType.toggle()
            self.collectionView.reloadData()
            typeLabel.text = "Show Cell Type: \(self.showCellType)"
        }))
        
        typeSwitch.isOn = showCellType

        let typeStack = UIStackView(arrangedSubviews: [typeLabel, typeSwitch])
        typeStack.spacing = 10
            
        
        let gifLabel = UILabel()
        gifLabel.text = "Include Gif: \(showGif)"
        
        let gifSwitch = UISwitch(frame: .zero, primaryAction: .init(handler: { [weak self] action in
            guard let self else { return }
            self.showGif.toggle()
            self.collectionView.reloadData()
            gifLabel.text = "Include Gif: \(self.showGif)"
        }))
        
        gifSwitch.isOn = showGif

        let gifStack = UIStackView(arrangedSubviews: [gifLabel, gifSwitch])
        gifStack.spacing = 10
        
        
        let menuItems: [UIAction]
        
        if #available(iOS 16.0, *) {
            menuItems = CellType.allCases.map { type in
                UIAction(title: type.rawValue) { [weak self] _ in
                    self?.cellType = type
                    self?.updateCellTypeLabelText()
                    self?.collectionView.reloadData()
                }
            }
        } else {
            menuItems = CellType.allCases.filter{$0 != .swiftui }.map { type in
                UIAction(title: type.rawValue) { [weak self] _ in
                    self?.cellType = type
                    self?.updateCellTypeLabelText()
                    self?.collectionView.reloadData()
                }
            }
        }
        
            
        let menu = UIMenu(title: "", image: nil, identifier: nil, options: [], children: menuItems)
        
        cellTypeButton.menu = menu
        cellTypeButton.setTitleColor(.systemBlue, for: .normal)
        cellTypeButton.showsMenuAsPrimaryAction = true
        updateCellTypeLabelText()
        
        let scrollButton = UIButton()
        let array = Array(0...10)
        let scrollItems = array.map { i in
            let title = i == 0 ? "N/A" : "\(i)"
            
            return UIAction(title: title) { [weak self] _ in
                self?.stopTimer()
                
                if i == 0 {
                    self?.scrollRateInSeconds = nil
                } else {
                    self?.scrollRateInSeconds = TimeInterval(i)
                    self?.startTimer(timeInterval: TimeInterval(i))
                }
                
                self?.collectionView.reloadData()
                scrollButton.setTitle("Scroll Rate: \(self?.scrollRateInSeconds?.description ?? "N/A")", for: .normal)
            }
        }
        
        scrollButton.menu = UIMenu(title: "Scroll Rate", image: nil, identifier: nil, options: [], children: scrollItems)
        scrollButton.setTitleColor(.systemBlue, for: .normal)
        scrollButton.showsMenuAsPrimaryAction = true
        scrollButton.setTitle("Scroll Rate: \(scrollRateInSeconds?.description ?? "N/A")", for: .normal)

        let stack = UIStackView(arrangedSubviews: [decelerationStack, typeStack, gifStack, cellTypeButton, scrollButton, collectionView])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 20
        stack.alignment = .center
        stack.distribution = .fill

        view.addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stack.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            collectionView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
    }
    
    // MARK: - Private Helper
    private func updateCellTypeLabelText() {
        cellTypeButton.setTitle("Cell Type: \(cellType.rawValue)", for: .normal)
    }
    
    private func startTimer(timeInterval: TimeInterval) {
        timer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: true) { [weak self] timer in
            self?.scrollToNextIndex()
        }
    }

    private func scrollToNextIndex() {
        if currentIndex.item == numberOfCarouselItems - 1 {
            currentIndex.item = 0
        } else {
            currentIndex.item += 1
        }
        
        collectionView.scrollToItem(at: currentIndex, at: .centeredHorizontally, animated: true)
    }
    
    private func registerCell() {
        cellRegistration = UICollectionView.CellRegistration<CarouselCell, String> { [weak self] (cell, indexPath, title) in
            guard let self else { return }
            
            let info = CellInfo(index: indexPath.item,
                                showGif: self.showGif,
                                cellType: self.showCellType ? self.cellType : nil,
                                imageTitle: title)
            cell.configure(info: info)
            cell.indexLabel.text = "\(indexPath.item)"
        }
        
        swiftUILegacyCellRegistration = UICollectionView.CellRegistration<SwiftUICollectionViewCell, String> { [weak self] (cell, indexPath, title) in
            guard let self else { return }
            
            let info = CellInfo(index: indexPath.item,
                                showGif: self.showGif,
                                cellType: self.showCellType ? self.cellType : nil,
                                imageTitle: title)
            
            let view = CarouselCellView(info: info)
            cell.configure(with: view, parent: self)
        }
        
        if #available(iOS 16.0, *) {
            swiftUICellRegistration = UICollectionView.CellRegistration<UICollectionViewCell, String> { [weak self] (cell, indexPath, title) in
                guard let self else { return }
                
                let info = CellInfo(index: indexPath.item,
                                    showGif: self.showGif,
                                    cellType: self.showCellType ? self.cellType : nil,
                                    imageTitle: title)
                
                let hostingConfiguration = UIHostingConfiguration {
                    CarouselCellView(info: info)
                }
                    .margins(.all, 0)
                
                cell.contentConfiguration = hostingConfiguration
            }
        }
    }
    
    //MARK: - Data Source
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let index = indexPath.item % carouselItems.count
        let item = carouselItems[index]
        
        
        switch cellType {
        case .uikit:
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
        case .swiftui:
            return collectionView.dequeueConfiguredReusableCell(using: swiftUICellRegistration, for: indexPath, item: item)
        case .swiftuiLegacy:
            return collectionView.dequeueConfiguredReusableCell(using: swiftUILegacyCellRegistration, for: indexPath, item: item)
        }
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
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        stopTimer()
        
        guard let layout = collectionView.collectionViewLayout as? CarouselLayout else { return }
        layout.startOfScrollIndex = layout.currentIndex
    }
}

