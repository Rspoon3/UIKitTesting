//
//  TableCell.swift
//  UIKitTesting
//
//  Created by Richard Witherspoon on 5/31/22.
//

import UIKit



class TableCell: UICollectionViewCell, UITextViewDelegate {
    private let textField = UITextField()
    private let textView = UITextView()
    private var textViewTextDidChange: ((String)->Void)?
    private let placeholder = "Testing"
    weak var collectionView: UICollectionView?

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground

        addViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let attribute = super.preferredLayoutAttributesFitting(layoutAttributes)

        if let layout = collectionView?.collectionViewLayout as? EqualHeightsUICollectionViewCompositionalLayout {
            layout.updateLayoutAttributesHeight(layoutAttributes: attribute)
            
//            if attribute.indexPath.item == 0 {
//                print("Here")
//                let size = CGSize(width: 50,
//                                  height: layoutAttributes.frame.height)
//                layoutAttributes.frame = .init(origin: layoutAttributes.frame.origin, size: size)
//            }
        }

        return attribute
    }
    
    func configure(text: String?, textViewTextDidChange: @escaping (String)->Void) {
        self.textViewTextDidChange = textViewTextDidChange
                
        if let text = text {
            textView.text = text
            textField.placeholder = nil
        } else {
            textView.text = nil
            textField.placeholder = placeholder
        }
    }
    
    private func addViews() {
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = .preferredFont(forTextStyle: .body)
        textView.delegate = self
        textView.isScrollEnabled = false
        
        textField.placeholder = placeholder
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = .preferredFont(forTextStyle: .body)
        textField.isUserInteractionEnabled = false
        
        contentView.addSubview(textView)
//        contentView.addSubview(textField)
        
        let padding: CGFloat = 10
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: contentView.topAnchor),
            textView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            textView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
//            textView.widthAnchor.constraint(greaterThanOrEqualToConstant: 300),
            
//            widthAnchor.constraint(equalToConstant: 300)
//
//            textField.topAnchor.constraint(equalTo: textView.topAnchor, constant: 7),
//            textView.bottomAnchor.constraint(equalTo: textView.bottomAnchor),
//            textField.leadingAnchor.constraint(equalTo: textView.leadingAnchor, constant: 6),
//            textField.trailingAnchor.constraint(equalTo: textView.trailingAnchor),
        ])
        
//        let divider = UIView()
//        divider.translatesAutoresizingMaskIntoConstraints = false
//        contentView.addSubview(divider)
//        divider.backgroundColor = .red
//        NSLayoutConstraint.activate([
//            divider.topAnchor.constraint(equalTo: contentView.topAnchor),
//            divider.heightAnchor.constraint(equalToConstant: 10),
//            divider.widthAnchor.constraint(equalToConstant: 800),
//            divider.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
//            divider.trailingAnchor.constraint(equalTo:  contentView.trailingAnchor),
//        ])
    }
    
    
    //MARK: - TextViewDelegate
    func textViewDidChange(_ textView: UITextView) {
        guard let text = textView.text else { return }
        textField.placeholder = text.isEmpty ? placeholder : nil
        
        textViewTextDidChange?(text)
    }
}
