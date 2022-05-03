//
//  ViewController.swift
//  UIKitTesting
//
//  Created by Richard Witherspoon on 3/1/22.
//

import UIKit
import FontAwesome


class ViewController: UIViewController, UICollectionViewDelegate{
    let fa = ["baseball-solid.SFSymbol", "bluetooth-b-brands.SFSymbol", "chalkboard-user-solid.SFSymbol", "database-solid.SFSymbol", "user-solid.SFSymbol"]
    
    let random = ["star", "person.3.fill", "bell", "figure.walk", "shareplay"]
    
    let test: [FontAwesome] = [.user, .perbyte, .chalkboardTeacher, .share, .cloudShowersHeavy]
    
    enum Section {
        case main
    }
    
    var dataSource: UICollectionViewDiffableDataSource<Section, Int>! = nil
    var collectionView: UICollectionView! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "List"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "star"))
        
        let attributes = [NSAttributedString.Key.font: UIFont.fontAwesome(ofSize: 20, style: .brands)]
        let barButton = UIBarButtonItem()
        barButton.setTitleTextAttributes(attributes,for: .normal)
        barButton.title = String.fontAwesomeIcon(name: .github)
        navigationItem.rightBarButtonItem = barButton
        
        configureHierarchy()
        configureDataSource()
    }
    
    /// - Tag: List
    private func createLayout() -> UICollectionViewLayout {
        let config = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        return UICollectionViewCompositionalLayout.list(using: config)
    }
    
    private func configureHierarchy() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(collectionView)
        collectionView.delegate = self
    }
    
    private func configureDataSource() {
        
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, Int> { (cell, indexPath, item) in
            var content = cell.defaultContentConfiguration()
            content.text = "\(item)"
            let value = Int.random(in: 1...3)
            if value == 1 {
                content.image = UIImage(systemName: self.random.randomElement()!)
            } else if value == 2 {
                content.image = UIImage(named: self.fa.randomElement()!)
                content.imageProperties.tintColor = .systemGreen
            } else {
//                content.image =  UIImage.fontAwesomeIcon(name: self.test.randomElement()!,
//                                                         style: .solid,
//                                                         textColor: .systemPurple,
//                                                         size: .init(width: 30, height: 30))
                content.image = UIImage(named: self.fa.randomElement()!)!
//                    .applyingSymbolConfiguration(.init(font: .preferredFont(forTextStyle: .largeTitle), scale: .large))
                    .applyingSymbolConfiguration(
                            UIImage.SymbolConfiguration(
                                pointSize: 40,
                                weight: .semibold,
                                scale: .large
                            )
                        )
                content.imageProperties.tintColor = .systemOrange
            }
            
            //            let r = Double.random(in: 20...40)
            //            content.image =  UIImage.fontAwesomeIcon(name: self.test.randomElement()!,
            //                                                     style: .solid,
//                                                     textColor: .systemPurple,
//                                                     size: .init(width: r, height: r))
            cell.contentConfiguration = content
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, Int>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, identifier: Int) -> UICollectionViewCell? in
            
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: identifier)
        }
        
        // initial data
        var snapshot = NSDiffableDataSourceSnapshot<Section, Int>()
        snapshot.appendSections([.main])
        snapshot.appendItems(Array(0..<94))
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}
    
    
    //    let imageView = UIImageView()
    
    //    override func viewDidLoad() {
    //        super.viewDidLoad()
    //
    //        imageView.translatesAutoresizingMaskIntoConstraints = false
    //        imageView.image = UIImage.fontAwesomeIcon(name: .user,
    //                                                  style: .solid,
    //                                                  textColor: .systemPurple,
    //                                                  size: .init(width: 4000, height: 4000))
    //
    //        view.addSubview(imageView)
    //
    //
    //        let label = UILabel()
    //        label.font = .fontAwesome(ofSize: 20, style: .brands)
    //        label.text = String.fontAwesomeIcon(name: .github)
    //        view.addSubview(label)
    //
    //        label.frame = .init(x: 100, y: 100, width: 100, height: 100)
    //
    //        NSLayoutConstraint.activate([
    //            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
    //            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
    //            imageView.widthAnchor.constraint(equalToConstant: 400),
    //            imageView.heightAnchor.constraint(equalToConstant: 400),
    //        ])
    //    }
//}

