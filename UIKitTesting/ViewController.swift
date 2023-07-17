//
//  ViewController.swift
//  UIKitTesting
//
//  Created by Richard Witherspoon on 3/1/22.
//

//
//  ViewController.swift
//  Feedback
//
//  Created by Richard Witherspoon on 6/8/22.
//

import UIKit
import LoremSwiftum
//https://stackoverflow.com/questions/71918534/make-nscollectionlayoutitem-heights-as-tall-as-the-nscollectionlayoutgroup-when

class ViewController: UIViewController {
    let sentences = Array(0..<33).map{_ in Lorem.sentences(1..<4)}
//    let sentences = [
//        "This is a short sentence for a short string",
//        "This week is WWDC and Im hoping that I can get some help with this long sentence so that it resizes properly. Maybe this should just be its own api? Idk I just need a long sentence for this to resize properly. Please be long enough now.",
//        "I was able to mock this expected behavior by changing the NSCollectionLayoutSize to be an absolute value of 500. This is not what I want.",
//
//
//        "We’ll start by reviewing how to build a grid with a flow layout, and then show you how to achieve the same design using a compositional layout while exploring the new APIs.",
//        "Who you taking shots at?",
//        "In addition to supplementary items, we can customize our section layout with decoration items. This will allow us to easily add backgrounds to our sections. The background view we’ll create is quite simple (a gray rectangle with a corner radius), so we’ll do it in code.",
//
//        "Third row"
//    ]
    
    enum Section {
        case main
    }
    
    var dataSource: UICollectionViewDiffableDataSource<Section, String>! = nil
    var collectionView: UICollectionView! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureDataSource()
        applyInitialSnapshot()
    }
    
    func createLayout() -> UICollectionViewLayout {
        let columns = 3
        let spacing = CGFloat(10)

        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0 / CGFloat(columns)),
                                              heightDimension: .uniformAcrossSiblings(estimate: 100))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .estimated(100))
//        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: columns)
  
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       repeatingSubitem: item,
                                                       count: columns)
        
        group.interItemSpacing = .fixed(spacing)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = spacing
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)

        return UICollectionViewCompositionalLayout(section: section)
        //return EqualHeightsUICollectionViewCompositionalLayout(section: section, columns: columns)
    }
    
    func configureHierarchy() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .systemBackground
        
        view.addSubview(collectionView)
    }
    
    func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<TextCell, String> { [weak self] (cell, indexPath, string) in
            cell.configure(text: string,
                           layout: self?.collectionView?.collectionViewLayout as? EqualHeightsUICollectionViewCompositionalLayout)
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, String>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, string: String) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: string)
        }
    }
    
    func applyInitialSnapshot(){
        var snapshot = NSDiffableDataSourceSnapshot<Section, String>()
        snapshot.appendSections([.main])
        snapshot.appendItems(sentences)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}
