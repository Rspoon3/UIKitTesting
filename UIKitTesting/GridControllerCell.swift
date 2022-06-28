//
//  GridControllerCell.swift
//  UIKitTesting
//
//  Created by Richard Witherspoon on 6/13/22.
//

import UIKit
import LoremSwiftum


protocol GridControllerCellDelegate: AnyObject {
    func scrollToBottom()
}

class GridControllerCell: UICollectionViewCell, UICollectionViewDelegate, UICollectionViewDataSource, SpreadsheetCollectionViewLayoutDelegate, UITextViewDelegate {
    var numberOfSections = 2
    let layout = SpreadsheetCollectionViewLayout()
    var collectionView: SelfSizingCollectionView!
    weak var invalidationDelegate: SpreadsheetCollectionViewLayoutInvalidationDelegate?
    weak var delegate: GridControllerCellDelegate?
    let sentences = Array(0..<3).map{ _ in
        Lorem.sentences(1..<3)
    }
    
    let sentences2 = Array(0..<3).map{ _ in
        Lorem.sentences(1..<3)
    }
    
    let sentences3 = Array(0..<3).map{ _ in
        Lorem.sentences(1..<3)
    }
    
    @objc func test(){
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        addViews()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(test),
                                               name: .init(rawValue: "GridViewChanged"),
                                               object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("not implemented")
    }
    
    func addViews() {
        layout.delegate = self
        collectionView = SelfSizingCollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemGroupedBackground
        collectionView.isDirectionalLockEnabled = true
        collectionView.bounces = false
        collectionView.register(TextCell.self, forCellWithReuseIdentifier: TextCell.reuseIdentifier)
        collectionView.register(ButtonCell.self, forCellWithReuseIdentifier: ButtonCell.reuseIdentifier)

        contentView.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo:  contentView.safeAreaLayoutGuide.trailingAnchor),
        ])
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        numberOfSections
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        sentences.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 2 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ButtonCell.reuseIdentifier, for: indexPath) as! ButtonCell
            cell.backgroundColor = .random()
            cell.buttonAction = { [weak self] in
                self?.numberOfSections += 1
                self?.collectionView.reloadData()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self?.delegate?.scrollToBottom()
                }
            }

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
    
    func textViewDidChange(_ textView: UITextView) {
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
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
