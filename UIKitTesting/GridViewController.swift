//
//  GridViewController.swift
//  UIKitTesting
//
//  Created by Richard Witherspoon on 6/13/22.
//

import UIKit
import LoremSwiftum


class GridViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    var collectionView: UICollectionView!
    let sentences = Array(0..<3).map{ _ in
        Lorem.sentences(1..<3)
    }
    
    let sentences2 = Array(0..<3).map{ _ in
        Lorem.sentences(1..<3)
    }
    
    let sentences3 = Array(0..<3).map{ _ in
        Lorem.sentences(1..<3)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let layout = SpreadsheetCollectionViewLayout()
        layout.delegate = self
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemGroupedBackground
        collectionView.isDirectionalLockEnabled = true
        collectionView.register(TextCell.self, forCellWithReuseIdentifier: TextCell.reuseIdentifier)
        collectionView.register(ButtonCell.self, forCellWithReuseIdentifier: ButtonCell.reuseIdentifier)

        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo:  view.safeAreaLayoutGuide.trailingAnchor),
        ])
    }
    
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        4
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        sentences.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 2 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ButtonCell.reuseIdentifier, for: indexPath) as! ButtonCell
            cell.backgroundColor = .random()

            return cell

        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TextCell.reuseIdentifier, for: indexPath) as! TextCell
            cell.backgroundColor = .random()
            cell.textView.delegate = self
            
            if indexPath.section == 0 {
                cell.textView.text = sentences[indexPath.item]
            } else if indexPath.section == 1 {
                cell.textView.text = sentences2[indexPath.item]
            } else if indexPath.section == 2 {
                cell.textView.text = sentences3[indexPath.item]
            }
            
            return cell
        }
    }
}

extension GridViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        collectionView.collectionViewLayout.invalidateLayout()
    }
}

// MARK: - SpreadsheetLayoutDelegate
extension GridViewController: SpreadsheetCollectionViewLayoutDelegate {
    func width(forColumn column: Int, collectionView: UICollectionView) -> CGFloat {
        let width = collectionView.frame.width / 2
        let minWidth: CGFloat = 300
        return column == sentences.count - 1 ? 100 : max(width - 50, minWidth)
    }
    
    func height(forItemAt: IndexPath, width: Double) -> CGFloat {
        let minHeight: CGFloat = 200
        let cell = collectionView.cellForItem(at: forItemAt) as? TextCell
        
        if forItemAt.item == 2 {
            return minHeight
        }


        
        let textView = UITextView()
        textView.font = UIFont.preferredFont(forTextStyle: .title2)
        textView.isScrollEnabled = false
        
        if let cell = cell {
            textView.text = cell.textView.text
        } else {
            if forItemAt.section == 0 {
                textView.text = sentences[forItemAt.item]
            } else if forItemAt.section == 1 {
                textView.text = sentences2[forItemAt.item]
            } else {
                textView.text = sentences3[forItemAt.item]
            }
        }
        
        let insets = 10.0
        let width = width - insets * 2
        let size = CGSize(width: width, height: UIView.layoutFittingCompressedSize.height)
        let layoutFittingSize = textView.systemLayoutSizeFitting(size,
                                                              withHorizontalFittingPriority: .required,
                                                              verticalFittingPriority: .fittingSizeLevel)
        
        let height = layoutFittingSize.height + (insets * 2)
        return max(height, minHeight)
    }
}
