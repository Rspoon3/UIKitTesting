//
//  SearchableViewController.swift
//  UIKitTesting
//
//  Created by Ricky Witherspoon on 6/4/25.
//

import SwiftUI

class SearchableViewController: UIViewController, UISearchResultsUpdating {
    private let searchController = UISearchController(searchResultsController: nil)
    private let hostingController = UIHostingController(rootView: SearchableContentView())

    init(title: String) {
        super.init(nibName: nil, bundle: nil)
        self.title = title
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
//        view.backgroundColor = .systemBackground

        setupSearchController()
        embedSwiftUIView()
    }
    
    
    private func embedSwiftUIView() {
        addChild(hostingController)
        view.addSubview(hostingController.view)
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        hostingController.didMove(toParent: self)
    }

    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search \(title ?? "")"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }

    func updateSearchResults(for searchController: UISearchController) {
        // Add your filtering logic here
        print("Searching for: \(searchController.searchBar.text ?? "")")
    }
}
