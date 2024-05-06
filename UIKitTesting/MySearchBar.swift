//
//  FakeSearchBar.swift
//  UIKitTesting
//
//  Created by Richard Witherspoon on 3/18/24.
//

import UIKit
import Combine

final class MySearchBar: UIView {
    let searchController: UISearchController
    private var magnifyingglassImageView: UIImageView?
    private var chevronButton: UIButton?
    private var retailerLocationsFeatureEntryPointButton: UIButton?
    private var clearButton: UIButton?
    private var myLeadingAnchor: NSLayoutConstraint?
    private let textField = UITextField()
    private let padding: CGFloat = 16
    private let height: CGFloat = 44
    private let placeholderView = UIView()
    let textChangePublisher = PassthroughSubject<String?, Never>()
    @Published private(set) var state: State = .placeholder {
        didSet {
            updateUIForState()
        }
    }
    
    private var cornerRadius: CGFloat {
        height / 2
    }
    
    enum State: Equatable {
        case placeholder
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
//        searchController.searchBar.backgroundColor = .systemRed.withAlphaComponent(0.3)
        searchController.searchBar.searchTextField.removeFromSuperview()
        searchController.searchBar.gestureRecognizers = nil
        
//        configureInitialViews()
        
        configurePlaceholder()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func updateUIForState() {
        switch state {
        case .placeholder:
            return
        case .inactive:
            updateToInactiveState()
        case .active(let text):
            updateToActiveState(text: text)
        }
    }
    
    private func updateToInactiveState() {
        UIView.performWithoutAnimation {
            textField.text?.removeAll()
            clearButton?.alpha = 0
        }
        
        textField.endEditing(true)
        
        guard searchController.isActive else { return }
        searchController.isActive = false

        myLeadingAnchor?.constant = -34

        UIView.animate(withDuration: 0.25) {
            self.chevronButton?.alpha = 0
            self.magnifyingglassImageView?.alpha = 1
            self.searchController.searchBar.layoutIfNeeded()
        }
    }
    
    private func updateToActiveState(text: String?) {
        UIView.performWithoutAnimation {
            clearButton?.alpha = (text?.isEmpty ?? true) ? 0 : 1
            
            if text == nil || text?.isEmpty ?? true {
                textField.text = "" //?.removeAll()
            }
        }
        
        guard !searchController.isActive else { return }
        
        searchController.isActive = true
        
        myLeadingAnchor?.constant = 0

        UIView.animate(withDuration: 0.25) {
            self.chevronButton?.alpha = 1
            self.magnifyingglassImageView?.alpha = 0
            self.searchController.searchBar.layoutIfNeeded()
        }
    }
    
    private func configurePlaceholder() {
        let searchBar = searchController.searchBar

        placeholderView.layer.borderColor = UIColor.gray.cgColor
        placeholderView.layer.borderWidth = 1
        placeholderView.layer.cornerRadius = cornerRadius
        placeholderView.backgroundColor = .gray
        placeholderView.translatesAutoresizingMaskIntoConstraints = false
        
        searchBar.addSubview(placeholderView)
        
        NSLayoutConstraint.activate([
            placeholderView.topAnchor.constraint(equalTo: searchBar.topAnchor),
            placeholderView.heightAnchor.constraint(equalToConstant: height),
            placeholderView.leadingAnchor.constraint(equalTo: searchBar.leadingAnchor, constant: padding),
            placeholderView.trailingAnchor.constraint(equalTo: searchBar.trailingAnchor, constant: -padding)
        ])
    }
    
    private func configureInitialInactiveViews() {
        let searchBar = searchController.searchBar
        
        textField.placeholder = "Search for something"
        textField.delegate = self
//        textField.backgroundColor = .systemPurple.withAlphaComponent(0.3)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.returnKeyType = .search

        chevronButton = UIButton(primaryAction: .init(handler: { [weak self] _ in
            self?.state = .inactive
        }))
        
        guard let chevronButton else { return }
        
        chevronButton.setImage(.init(systemName: "chevron.left"), for: .normal)
        chevronButton.imageView?.contentMode = .scaleAspectFit
        chevronButton.translatesAutoresizingMaskIntoConstraints = false
        chevronButton.alpha = 0
        
        magnifyingglassImageView = UIImageView(image: .init(systemName: "magnifyingglass"))
        guard let magnifyingglassImageView else { return }
        
        magnifyingglassImageView.translatesAutoresizingMaskIntoConstraints = false
        magnifyingglassImageView.alpha = 1
        
        clearButton = UIButton(primaryAction: .init(handler: { [weak self] _ in
            self?.state = .active(text: nil)
        }))
        
        guard let clearButton else { return }
        
        clearButton.setImage(.init(systemName: "xmark"), for: .normal)
        clearButton.translatesAutoresizingMaskIntoConstraints = false
        clearButton.alpha = 0

        
        let tap = BindableGestureRecognizer { [weak self] in
            guard let self, !textField.isFirstResponder else { return }
            textField.becomeFirstResponder()
        }
        
        let stackView = UIStackView(arrangedSubviews: [magnifyingglassImageView, textField, clearButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillProportionally
        stackView.alignment = .center
        stackView.spacing = 10
        stackView.layer.borderColor = UIColor.gray.cgColor
        stackView.layer.borderWidth = 1
        stackView.layer.cornerRadius = cornerRadius
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        stackView.isLayoutMarginsRelativeArrangement = true
//        stackView.backgroundColor = .systemGreen.withAlphaComponent(0.3)
        stackView.addGestureRecognizer(tap)
        
        retailerLocationsFeatureEntryPointButton = UIButton(primaryAction: nil)
        guard let retailerLocationsFeatureEntryPointButton else { return }

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
            
            textField.topAnchor.constraint(equalTo: stackView.topAnchor),
            textField.bottomAnchor.constraint(equalTo: stackView.bottomAnchor),
            
            stackView.topAnchor.constraint(equalTo: searchBar.topAnchor),
            stackView.heightAnchor.constraint(equalToConstant: height),
            stackView.leadingAnchor.constraint(equalTo: searchBar.leadingAnchor, constant: padding),
            stackView.trailingAnchor.constraint(equalTo: retailerLocationsFeatureEntryPointButton.leadingAnchor, constant: -padding)
        ])
    }
    
    func removePlaceholder() {
        guard state == .placeholder else { return }
        placeholderView.removeFromSuperview()
        configureInitialInactiveViews()
    }
}

extension MySearchBar: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print(#function)
        DispatchQueue.main.async {
            self.state = .active(text: textField.text)
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        print(#function, textField.text)
        state = .active(text: textField.text)
        textChangePublisher.send(textField.text)
        return true
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return false
    }
}
