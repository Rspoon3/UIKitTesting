//
//  TableCell.swift
//  UIKitTesting
//
//  Created by Richard Witherspoon on 5/31/22.
//

import UIKit



class TableCell: UICollectionViewCell, UITextViewDelegate {
    private let textLabel = UILabel()
    private let textField = UITextField()
    private let textView = UITextView()
    private let divider = UIView()
    private var topConstraint: NSLayoutConstraint!
    private var textViewTextDidChange: ((String)->Void)?
    private let placeholder = "Testing"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(headerText: String?, text: String?, textViewTextDidChange: @escaping (String)->Void) {
        self.textViewTextDidChange = textViewTextDidChange
        
        topConstraint.isActive = false

        if let text = headerText {
            textLabel.text = text
            topConstraint = textView.topAnchor.constraint(equalTo: divider.bottomAnchor)
        } else {
            topConstraint = textView.topAnchor.constraint(equalTo: contentView.topAnchor)
            textLabel.text = nil
        }
        
        topConstraint.isActive = true
        
        if let text = text {
            textView.text = text
            textField.placeholder = nil
        } else {
            textView.text = nil
            textField.placeholder = placeholder
        }
    }
    
    private func addViews() {
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.textAlignment = .center
        textLabel.backgroundColor = .systemMint
        
        divider.translatesAutoresizingMaskIntoConstraints = false
        
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = .preferredFont(forTextStyle: .body)
        textView.delegate = self
        
        textField.placeholder = placeholder
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = .preferredFont(forTextStyle: .body)
        textField.isUserInteractionEnabled = false
        
        contentView.addSubview(textLabel)
        contentView.addSubview(divider)
        contentView.addSubview(textView)
        contentView.addSubview(textField)
        
        topConstraint = textView.topAnchor.constraint(equalTo: divider.bottomAnchor)

        
        NSLayoutConstraint.activate([
            textLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            textLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.25),
            textLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            textLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            divider.topAnchor.constraint(equalTo: textLabel.bottomAnchor),
            divider.heightAnchor.constraint(equalToConstant: 2),
            divider.leadingAnchor.constraint(equalTo: textLabel.leadingAnchor),
            divider.trailingAnchor.constraint(equalTo: textLabel.trailingAnchor),

            topConstraint,
            textView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            textView.leadingAnchor.constraint(equalTo: textLabel.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: textLabel.trailingAnchor),
            
            textField.topAnchor.constraint(equalTo: textView.topAnchor, constant: 7),
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

