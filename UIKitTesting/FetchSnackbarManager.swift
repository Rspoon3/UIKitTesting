//
//  FetchSnackbarManager.swift
//  UIKitTesting
//
//  Created by Richard Witherspoon on 3/21/24.
//

import UIKit
import Combine

extension UIApplication {
    var keyWindow: UIWindow? {
        return connectedScenes
            .filter { $0.activationState == .foregroundActive }
            .first(where: { $0 is UIWindowScene })
            .flatMap({ $0 as? UIWindowScene })?.windows
            .first(where: \.isKeyWindow)
    }
}

@MainActor
final class FetchSnackbarManager {
    static let shared = FetchSnackbarManager()
    private let window: UIWindow
    private var anchor: NSLayoutConstraint?
    @Published private var snackBarQueue = [SnackbarView]()
    private var subscriptions = Set<AnyCancellable>()
    
    private init?() {
        guard let window = UIApplication.shared.keyWindow else { return nil }
        self.window = window
    }
    
    func addSnackbar() {
        Task {
            let shouldAddNow = snackBarQueue.isEmpty
            let snackBarView = SnackbarView(config: .previewData)
            
            snackBarView.dismiss = { [weak self] in
                Task {
                    await self?.removeSnackbar(snackBarView: snackBarView)
                }
            }
            
            snackBarQueue.append(snackBarView)
            
            if shouldAddNow {
                await addToWindow(snackBarView: snackBarView)
            }
        }
    }
    
    func addToWindow(snackBarView: SnackbarView) async {
        try? await Task.sleep(for: .milliseconds(800))
        window.addSubview(snackBarView)
        
        anchor = snackBarView.topAnchor.constraint(equalTo: window.bottomAnchor)
        
        NSLayoutConstraint.activate([
            snackBarView.centerXAnchor.constraint(equalTo: window.centerXAnchor),
            anchor!
        ])
        
        window.layoutIfNeeded()
        
        anchor?.isActive = false
        anchor = snackBarView.bottomAnchor.constraint(
            equalTo: window.bottomAnchor,
            constant: -94
        )
        anchor?.isActive = true
        
        await UIView.animate(
            withDuration: 0.2,
            delay: 0,
            usingSpringWithDamping: 1,
            initialSpringVelocity: 30,
            options: [.allowAnimatedContent, .allowUserInteraction]
        ) { [weak self] in
            self?.window.layoutIfNeeded()
        }
        
        try? await Task.sleep(for: .seconds(3))
        await removeSnackbar(snackBarView: snackBarView)
    }
    
    /// Removes an existing snackbar that is showing
    private func removeSnackbar(snackBarView: SnackbarView) async {
        guard snackBarQueue.contains(snackBarView) else { return }
        anchor?.isActive = false
        anchor = snackBarView.topAnchor.constraint(equalTo: window.bottomAnchor)
        anchor?.isActive = true
        
        await UIView.animate(withDuration: 0.2) { [weak self] in
            self?.window.layoutIfNeeded()
        }
        
        snackBarView.removeFromSuperview()
        anchor = nil
        snackBarQueue.removeFirst()
        
        guard let nextSnackbarView = snackBarQueue.first else { return }
        await addToWindow(snackBarView: nextSnackbarView)
    }
}


extension UIColor {
    static func random(alpha: CGFloat = 1.0) -> UIColor {
        let r = CGFloat.random(in: 0...1)
        let g = CGFloat.random(in: 0...1)
        let b = CGFloat.random(in: 0...1)
        
        return UIColor(red: r, green: g, blue: b, alpha: alpha)
    }
    
    static var lightRandom: UIColor {
        random(alpha: 0.3)
    }
}

