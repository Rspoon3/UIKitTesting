//
//  FakeSearchBar.swift
//  UIKitTesting
//
//  Created by Richard Witherspoon on 3/18/24.
//

import UIKit
import Combine

final class FakeSearchBar: UIView {
    private var subscriptions = Set<AnyCancellable>()
    let searchController: UISearchController
    private var magnifyingglassImageView: UIImageView!
    private var chevronButton: UIButton!
    private var retailerLocationsFeatureEntryPointButton: UIButton!
    private var clearButton: UIButton!
    private var myLeadingAnchor: NSLayoutConstraint?
    private let textField = UITextField()
    @Published private var state: State = .inactive {
        didSet {
            updateUIForState()
        }
    }
    
    enum State: Equatable {
        case inactive
        case active(text: String?)
    }
    
    init(searchController: UISearchController) {
        self.searchController = searchController
        super.init(frame: .zero)
        
        searchController.searchBar.placeholder = "Search for a username"
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.automaticallyShowsCancelButton = false
        searchController.showsSearchResultsController = true
        searchController.searchBar.backgroundColor = .systemRed
        searchController.searchBar.searchTextField.isHidden = true
        searchController.delegate = self
        searchController.searchResultsUpdater = self
        
        configureInitialViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func updateUIForState() {
        print(state)
        switch state {
        case .inactive:
            configureInactiveState()
        case .active(let text):
            configureActiveState(text: text)
        }
    }
    
    private func configureInactiveState() {
                
        UIView.performWithoutAnimation {
            textField.text = ""
            clearButton.alpha = 0
        }
        
        textField.endEditing(true)
        
        guard searchController.isActive else { return }
        searchController.isActive = false

        myLeadingAnchor?.constant = -34

        UIView.animate(withDuration: 0.25) {
            self.chevronButton.alpha = 0
            self.magnifyingglassImageView.alpha = 1
            self.searchController.searchBar.layoutIfNeeded()
        }
    }
    
    private func configureActiveState(text: String?) {
        UIView.performWithoutAnimation {
            clearButton.alpha = (text?.isEmpty ?? true) ? 0 : 1
            
            if text == nil || text?.isEmpty ?? true {
                textField.text?.removeAll()
            }
        }
        
        guard !searchController.isActive else { return }
        
        searchController.isActive = true
        
        myLeadingAnchor?.constant = 0

        UIView.animate(withDuration: 0.25) {
            self.chevronButton.alpha = 1
            self.magnifyingglassImageView.alpha = 0
            self.searchController.searchBar.layoutIfNeeded()
        }
    }
    
    func configureInitialViews() {
        let searchBar = searchController.searchBar
        textField.placeholder = "Search for something"
        textField.delegate = self
        
        chevronButton = UIButton(primaryAction: .init(handler: { [weak self] _ in
            self?.state = .inactive
        }))
        
        chevronButton.setImage(.init(systemName: "chevron.left"), for: .normal)
        chevronButton.imageView?.contentMode = .scaleAspectFit
        chevronButton.translatesAutoresizingMaskIntoConstraints = false
        chevronButton.alpha = 0
        
        magnifyingglassImageView = UIImageView(image: .init(systemName: "magnifyingglass"))
        magnifyingglassImageView.translatesAutoresizingMaskIntoConstraints = false
        magnifyingglassImageView.alpha = 1
        
        clearButton = UIButton(primaryAction: .init(handler: { [weak self] _ in
            self?.state = .active(text: nil)
        }))
        
        clearButton.setImage(.init(systemName: "xmark"), for: .normal)
        clearButton.translatesAutoresizingMaskIntoConstraints = false
        clearButton.alpha = 0

        let stackView = UIStackView(arrangedSubviews: [magnifyingglassImageView, textField, clearButton])
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
        searchBar.addSubview(chevronButton)
        searchBar.addSubview(retailerLocationsFeatureEntryPointButton)
        
        let searchBarButtonSize: CGFloat = 24
        let padding: CGFloat = 16
        NSLayoutConstraint.activate([
            retailerLocationsFeatureEntryPointButton.heightAnchor.constraint(equalToConstant: searchBarButtonSize),
            retailerLocationsFeatureEntryPointButton.widthAnchor.constraint(equalToConstant: searchBarButtonSize),
            retailerLocationsFeatureEntryPointButton.centerYAnchor.constraint(equalTo: searchBar.centerYAnchor),
            myLeadingAnchor!,
            
            clearButton.heightAnchor.constraint(equalToConstant: 20),
            clearButton.widthAnchor.constraint(equalToConstant: 20),
            
            chevronButton.heightAnchor.constraint(equalToConstant: 24),
            chevronButton.widthAnchor.constraint(equalToConstant: 24),
            
            magnifyingglassImageView.topAnchor.constraint(equalTo: chevronButton.topAnchor),
            magnifyingglassImageView.bottomAnchor.constraint(equalTo: chevronButton.bottomAnchor),
            magnifyingglassImageView.leadingAnchor.constraint(equalTo: chevronButton.leadingAnchor),
            magnifyingglassImageView.trailingAnchor.constraint(equalTo: chevronButton.trailingAnchor),
            
            stackView.centerYAnchor.constraint(equalTo: searchBar.centerYAnchor),
            stackView.heightAnchor.constraint(equalToConstant: 44),
            stackView.leadingAnchor.constraint(equalTo: searchBar.leadingAnchor, constant: padding),
            stackView.trailingAnchor.constraint(equalTo: retailerLocationsFeatureEntryPointButton.leadingAnchor, constant: -padding)
        ])
    }
}

extension FakeSearchBar: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("textFieldDidBeginEditing")
        state = .active(text: textField.text)
    }
    
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        state = .inactive
//    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        print("textFieldDidChangeSelection")
        state = .active(text: textField.text)
    }
}


extension FakeSearchBar: UISearchResultsUpdating, UISearchControllerDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    
    func willPresentSearchController(_ searchController: UISearchController) {
        print(#function)
        guard state == .inactive else { return }
        textField.becomeFirstResponder()
        state = .active(text: textField.text)
    }
    
    func willDismissSearchController(_ searchController: UISearchController) {
        print(#function)
    }
}
