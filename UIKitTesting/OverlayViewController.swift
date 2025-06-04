//
//  OverlayViewController.swift
//  UIKitTesting
//
//  Created by Ricky Witherspoon on 6/4/25.
//

import SwiftUI

final class OverlayViewController: UIViewController {
    private let hostingController = UIHostingController(rootView: SearchableContentView())

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        embedSwiftUIView()
    }

    func present(over presenter: UIViewController) {
        modalPresentationStyle = .overFullScreen
        presenter.present(self, animated: false, completion: nil)
    }
    
    private func embedSwiftUIView() {
        hostingController.view.backgroundColor = .clear
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
}
