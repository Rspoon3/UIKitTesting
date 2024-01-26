//
//  ViewController.swift
//  UIKitTesting
//
//  Created by Richard Witherspoon on 3/1/22.
//

import SwiftUI

class ViewController: UIViewController, UICollectionViewDelegate {
    var dataSource: UICollectionViewDiffableDataSource<Section, String>! = nil
    var collectionView: UICollectionView! = nil
    var items = Array(1...100).map{"This is item \($0)"}
    enum Section: String {
        case main
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "List"
        configureCollectionView()
        configureDataSource()
        applyInitialSnapshot()
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let config = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        return UICollectionViewCompositionalLayout.list(using: config)
    }
    
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        navigationController?.pushViewController(ColorVC(color: .systemGreen), animated: true)
        collectionView.deselectItem(at: indexPath, animated: false)
    }
}


extension UIApplication {
    var topViewController: UIViewController? {
        var topViewController: UIViewController? = nil
        
        topViewController = connectedScenes.compactMap {
            return ($0 as? UIWindowScene)?.windows.filter { $0.isKeyWindow  }.first?.rootViewController
        }.first
        
        if let presented = topViewController?.presentedViewController {
            topViewController = presented
        } else if let navController = topViewController as? UINavigationController {
            topViewController = navController.topViewController
        } else if let tabBarController = topViewController as? UITabBarController {
            topViewController = tabBarController.selectedViewController
        }
        
        return topViewController
    }
}



final class ToastManager {
    private var anchor: NSLayoutConstraint?
    private var swiftuiView: UIView?
    private(set) var isShowingToast = false
    let window = UIApplication.shared.keyWindow!
    static let shared = ToastManager()
    
    private init() {
        
    }

//    var topVC: UIViewController? {
//        UIApplication.shared.topViewController
//    }
    
    private func removeToast() {
//        guard let topVC else { return }
        
        if let swiftuiView {
            anchor?.isActive = false
            anchor = swiftuiView.bottomAnchor.constraint(equalTo: window.topAnchor)
            anchor?.isActive = true
        }
        
        UIView.animate(withDuration: 1) { [weak self] in
            self?.window.layoutIfNeeded()
        } completion: { [weak self] _ in
            self?.swiftuiView?.removeFromSuperview()
            self?.swiftuiView = nil
            self?.anchor = nil
            self?.isShowingToast = false
        }
    }
    
    func addToast() {
        guard
            !isShowingToast
        else {
            return
        }
        

        
        isShowingToast = true
        
        let viewModel = OfferReactionSnackBarView.ViewModel()
        let snackBarView = OfferReactionSnackBarView(viewModel: viewModel){ [weak self] in
            if viewModel.count == 5 {
                self!.removeToast()
            }
        }.ignoresSafeArea()
        
        let hostingVC = UIHostingController(rootView: snackBarView)
        hostingVC.sizingOptions = .intrinsicContentSize
        
        swiftuiView = hostingVC.view!
        swiftuiView?.translatesAutoresizingMaskIntoConstraints = false
        swiftuiView?.backgroundColor = .clear
        
//        window.addChild(hostingVC)
        window.addSubview(swiftuiView!)
//        hostingVC.didMove(toParent: topVC)
        
        swiftuiView?.centerXAnchor.constraint(equalTo: window.centerXAnchor).isActive = true
        
        anchor = swiftuiView!.bottomAnchor.constraint(equalTo: window.topAnchor)
        anchor?.isActive = true
        
        window.setNeedsLayout()
        window.layoutIfNeeded()
        
        anchor?.isActive = false
        anchor = swiftuiView!.topAnchor.constraint(equalTo: window.safeAreaLayoutGuide.topAnchor, constant: 20)
        anchor?.isActive = true
        
        UIView.animate(withDuration: 1) { [weak self] in
            self?.window.layoutIfNeeded()
        }
    }
}


class ColorVC: UIViewController {
    let color: UIColor
    let manager = ToastManager.shared

    init(color: UIColor) {
        self.color = color
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = color
        
        Task {
            try await Task.sleep(for: .seconds(1))
            manager.addToast()
        }
    }
}
