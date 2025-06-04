//
//  FullscreenOverlay.swift
//  UIKitTesting
//
//  Created by Ricky Witherspoon on 6/4/25.
//

import SwiftUI

final class FullscreenOverlay {
    static let shared = FullscreenOverlay()
    private var window: UIWindow?

    func show<Content: View>(@ViewBuilder content: @escaping () -> Content) {
        guard window == nil else { return }

        // Get the current window scene
        guard let windowScene = UIApplication.shared
            .connectedScenes
            .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene else {
            return
        }

        // Create a transparent window
        let overlayWindow = UIWindow(windowScene: windowScene)
        overlayWindow.windowLevel = .alert + 1
        overlayWindow.backgroundColor = .clear

        // Make a root view controller with a container UIView
        let rootVC = UIViewController()
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        rootVC.view.addSubview(containerView)
        
        let mainWindow = windowScene.windows.first(where: { $0.isKeyWindow })
        let tabBarHeight = mainWindow?.rootViewController
            .flatMap { ($0 as? UITabBarController)?.tabBar.frame.height } ?? 0

        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: rootVC.view.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: rootVC.view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: rootVC.view.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: rootVC.view.bottomAnchor, constant: -tabBarHeight)
        ])

        // Embed the SwiftUI content
        let hosting = UIHostingController(rootView: content())
        hosting.view.translatesAutoresizingMaskIntoConstraints = false
        hosting.view.backgroundColor = .clear
        containerView.addSubview(hosting.view)

        NSLayoutConstraint.activate([
            hosting.view.topAnchor.constraint(equalTo: containerView.topAnchor),
            hosting.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            hosting.view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            hosting.view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
        ])

        // Show it
        overlayWindow.rootViewController = rootVC
        overlayWindow.makeKeyAndVisible()
        self.window = overlayWindow
    }

    func dismiss() {
        window?.isHidden = true
        window = nil
    }
}
