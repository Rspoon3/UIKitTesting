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

    private var dataSource: UICollectionViewDiffableDataSource<Section, String>! = nil
    private var collectionView: UICollectionView! = nil
    private let items = Array(1...100).map{"This is item \($0)"}
    
    enum Section: String {
        case main
    }
    
    init(title: String) {
        super.init(nibName: nil, bundle: nil)
        self.title = title
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupSearchController()
//        embedSwiftUIView()
        
        navigationItem.title = "List"
        configureCollectionView()
        configureDataSource()
        applyInitialSnapshot()
        
        Task {
            try? await Task.sleep(for: .seconds(2))
            let overlayVC = OverlayViewController()
            overlayVC.present(over: self)
        }
        
        // In your SearchableViewController, replace the Task block with:
//        Task {
//            try? await Task.sleep(for: .seconds(2))
//            
//            let animatedCircle = AnimatedCircleView()
//            animatedCircle.show()
//        }
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
    
    private func createLayout() -> UICollectionViewLayout {
        let config = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        return UICollectionViewCompositionalLayout.list(using: config)
    }
    
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .systemBackground
        view.addSubview(collectionView)
    }
    
    private func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, String> { (cell, indexPath, item) in
            var content = cell.defaultContentConfiguration()
            content.text = item
            cell.contentConfiguration = content
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, String>(collectionView: collectionView) {
            (collectionView, indexPath, identifier) -> UICollectionViewCell? in
            
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: identifier)
        }
    }
    
    private func applyInitialSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, String>()
        snapshot.appendSections([.main])
        snapshot.appendItems(items)
        
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}


final class AnimatedCircleView: UIView {
    private var widthConstraint: NSLayoutConstraint!
    private var heightConstraint: NSLayoutConstraint!
    private var centerXConstraint: NSLayoutConstraint!
    private var centerYConstraint: NSLayoutConstraint!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        backgroundColor = .systemBlue
        layer.masksToBounds = true
        
        // Start with size 50x50 and circular shape
        widthConstraint = widthAnchor.constraint(equalToConstant: 50)
        heightConstraint = heightAnchor.constraint(equalToConstant: 50)
        widthConstraint.isActive = true
        heightConstraint.isActive = true
        
        // Make it circular
        layer.cornerRadius = 25
    }
    
    func show(in window: UIWindow? = nil) {
        guard let targetWindow = window ?? UIApplication.shared.windows.first ??
                                  UIApplication.shared.connectedScenes
                                    .compactMap({ $0 as? UIWindowScene })
                                    .first?.windows.first else { return }
        
        targetWindow.addSubview(self)
        translatesAutoresizingMaskIntoConstraints = false
        
        // Start position: bottom right (with some padding from edges)
        let startX = targetWindow.bounds.width - 75  // 50 (width) + 25 (padding)
        let startY = targetWindow.bounds.height - 125 // 50 (height) + 75 (padding from bottom)
        
        centerXConstraint = centerXAnchor.constraint(equalTo: targetWindow.leadingAnchor, constant: startX)
        centerYConstraint = centerYAnchor.constraint(equalTo: targetWindow.topAnchor, constant: startY)
        
        NSLayoutConstraint.activate([
            centerXConstraint,
            centerYConstraint
        ])
        
        // Force layout to establish starting position
        targetWindow.layoutIfNeeded()
        
        // Start animation after a brief delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.animateToCenter(in: targetWindow)
        }
    }
    
    private func animateToCenter(in window: UIWindow) {
        // Calculate center position
        let centerX = window.bounds.width / 2
        let centerY = window.bounds.height / 2
        
        // Animate constraints and size
        UIView.animate(
            withDuration: 3.0,
            delay: 0,
            usingSpringWithDamping: 0.8,
            initialSpringVelocity: 0.5,
            options: [.curveEaseInOut],
            animations: {
                // Update position constraints
                self.centerXConstraint.constant = centerX
                self.centerYConstraint.constant = centerY
                
                // Update size constraints
                self.widthConstraint.constant = 200
                self.heightConstraint.constant = 200
                
                // Update corner radius to maintain circle shape
                self.layer.cornerRadius = 100
                
                // Force layout update
                window.layoutIfNeeded()
            },
            completion: { _ in
                print("🔵 Circle animation completed!")
                // Optional: add a pulsing effect when animation completes
                self.addPulseEffect()
            }
        )
    }
    
    private func addPulseEffect() {
        UIView.animate(
            withDuration: 1.0,
            delay: 0,
            options: [.repeat, .autoreverse, .curveEaseInOut],
            animations: {
                self.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            }
        )
    }
    
    func hide() {
        UIView.animate(
            withDuration: 0.5,
            animations: {
                self.alpha = 0
                self.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            },
            completion: { _ in
                self.removeFromSuperview()
            }
        )
    }
    
    // Pass through touches - circle is just visual
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        return nil // Always pass through
    }
}
