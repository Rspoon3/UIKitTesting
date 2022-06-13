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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        layer.borderWidth = 1
        layer.borderColor = UIColor.black.cgColor

        addViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        
        textField.placeholder = placeholder
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = .preferredFont(forTextStyle: .body)
        textField.isUserInteractionEnabled = false
        
        contentView.addSubview(textView)
        contentView.addSubview(textField)
        
        let padding: CGFloat = 10
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            textView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding),
            textView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            textView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            
            textField.topAnchor.constraint(equalTo: textView.topAnchor, constant: 7),
            textView.bottomAnchor.constraint(equalTo: textView.bottomAnchor),
            textField.leadingAnchor.constraint(equalTo: textView.leadingAnchor, constant: 6),
            textField.trailingAnchor.constraint(equalTo: textView.trailingAnchor),
        ])
    }
    
    
    //MARK: - TextViewDelegate
    func textViewDidChange(_ textView: UITextView) {
        guard let text = textView.text else { return }
        textField.placeholder = text.isEmpty ? placeholder : nil
        
        textViewTextDidChange?(text)
    }
}
