//
//  FakeSearchBar.swift
//  UIKitTesting
//
//  Created by Richard Witherspoon on 3/18/24.
//

import UIKit

final class FakeSearchBar: UIView {
    private var leadingImageView: UIImageView!
    private var leadingButton: UIButton!
    private var retailerLocationsFeatureEntryPointButton: UIButton!
    private var myLeadingAnchor: NSLayoutConstraint?
    private var searchController: UISearchController?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(
        using searchController: UISearchController
    ) {
        self.searchController = searchController
        
        let searchBar = searchController.searchBar
        let textField = UITextField()
        textField.placeholder = "Search for something"
        textField.delegate = self
        
        leadingButton = UIButton(primaryAction: .init(handler: { _ in
            textField.text?.removeAll()
            textField.endEditing(true)
            searchController.isActive = false
        }))
        
        leadingButton.setImage(.init(systemName: "chevron.left"), for: .normal)
        leadingButton.imageView?.contentMode = .scaleAspectFit
        leadingButton.translatesAutoresizingMaskIntoConstraints = false
        leadingButton.alpha = 0
        
        leadingImageView = UIImageView(image: .init(systemName: "magnifyingglass"))
        leadingImageView.translatesAutoresizingMaskIntoConstraints = false
        leadingImageView.alpha = 1
        
        
        let closeButton = UIButton(primaryAction: .init(handler: { _ in
            textField.text?.removeAll()
            textField.endEditing(true)
        }))
        
        closeButton.setImage(.init(systemName: "xmark"), for: .normal)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        
        let stackView = UIStackView(arrangedSubviews: [leadingImageView, textField, closeButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillProportionally
        stackView.alignment = .center
        stackView.spacing = 10
        stackView.layer.borderColor = UIColor.gray.cgColor
        stackView.layer.borderWidth = 1
        stackView.layer.cornerRadius = 44 / 2
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        stackView.isLayoutMarginsRelativeArrangement = true
        
        retailerLocationsFeatureEntryPointButton = UIButton(primaryAction: nil)
        retailerLocationsFeatureEntryPointButton.setImage(.init(systemName: "book"), for: .normal)
        retailerLocationsFeatureEntryPointButton.translatesAutoresizingMaskIntoConstraints = false
        
        myLeadingAnchor = retailerLocationsFeatureEntryPointButton.leadingAnchor.constraint(
            equalTo: searchBar.trailingAnchor,
            constant: -34
        )
        
        searchBar.addSubview(stackView)
        searchBar.addSubview(leadingButton)
        searchBar.addSubview(retailerLocationsFeatureEntryPointButton)
        
        let searchBarButtonSize: CGFloat = 24
        let padding: CGFloat = 16
        NSLayoutConstraint.activate([
            retailerLocationsFeatureEntryPointButton.heightAnchor.constraint(equalToConstant: searchBarButtonSize),
            retailerLocationsFeatureEntryPointButton.widthAnchor.constraint(equalToConstant: searchBarButtonSize),
            retailerLocationsFeatureEntryPointButton.centerYAnchor.constraint(equalTo: searchBar.centerYAnchor),
            myLeadingAnchor!,
            
            
            closeButton.heightAnchor.constraint(equalToConstant: 20),
            closeButton.widthAnchor.constraint(equalToConstant: 20),
            
            leadingButton.heightAnchor.constraint(equalToConstant: 24),
            leadingButton.widthAnchor.constraint(equalToConstant: 24),
            
            leadingImageView.topAnchor.constraint(equalTo: leadingButton.topAnchor),
            leadingImageView.bottomAnchor.constraint(equalTo: leadingButton.bottomAnchor),
            leadingImageView.leadingAnchor.constraint(equalTo: leadingButton.leadingAnchor),
            leadingImageView.trailingAnchor.constraint(equalTo: leadingButton.trailingAnchor),
            
            stackView.centerYAnchor.constraint(equalTo: searchBar.centerYAnchor),
            stackView.heightAnchor.constraint(equalToConstant: 44),
            stackView.leadingAnchor.constraint(equalTo: searchBar.leadingAnchor, constant: padding),
            stackView.trailingAnchor.constraint(equalTo: retailerLocationsFeatureEntryPointButton.leadingAnchor, constant: -padding)
        ])
    }
}


extension FakeSearchBar: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        myLeadingAnchor?.constant = -34
        print("THERa;sdlkfj;las")
        
        UIView.animate(withDuration: 0.25) {
            self.leadingButton.alpha = 1
            self.leadingImageView.alpha = 0
            self.searchController?.searchBar.layoutIfNeeded()
        }
        
        
        searchController?.isActive = true
        print("HERE")
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        myLeadingAnchor?.constant = 0
        
        UIView.animate(withDuration: 0.25) {
            self.leadingButton.alpha = 0
            self.leadingImageView.alpha = 1
            self.searchController?.searchBar.layoutIfNeeded()
        }
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
       
        
        searchController?.searchBar.searchTextField.text = textField.text
    }
}
