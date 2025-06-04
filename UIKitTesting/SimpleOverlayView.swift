//
//  SimpleOverlayView.swift
//  UIKitTesting
//
//  Created by Ricky Witherspoon on 6/4/25.
//

import SwiftUI

final class SimpleOverlayView: UIView {
    private let hostingController = UIHostingController(rootView: SearchableContentView())
    private weak var parentViewController: UIViewController?
    
    init(parentViewController: UIViewController) {
        self.parentViewController = parentViewController
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        backgroundColor = .clear
        
        // Add SwiftUI content
        hostingController.view.backgroundColor = .clear
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(hostingController.view)
        
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: topAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: bottomAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
        
        // Add hosting controller as child if we have a parent
        if let parent = parentViewController {
            parent.addChild(hostingController)
            hostingController.didMove(toParent: parent)
        }
    }
    
    func show() {
        guard let window = UIApplication.shared.windows.first ?? 
                          UIApplication.shared.connectedScenes
                            .compactMap({ $0 as? UIWindowScene })
                            .first?.windows.first else { return }
        
        translatesAutoresizingMaskIntoConstraints = false
        window.addSubview(self)
        
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: window.safeAreaLayoutGuide.topAnchor),
            leadingAnchor.constraint(equalTo: window.leadingAnchor),
            trailingAnchor.constraint(equalTo: window.trailingAnchor),
            bottomAnchor.constraint(equalTo: window.bottomAnchor)
        ])
    }
    
    func hide() {
        hostingController.willMove(toParent: nil)
        hostingController.removeFromParent()
        removeFromSuperview()
    }
    
    // Pass through touches except for interactive SwiftUI content
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let hitView = super.hitTest(point, with: event)
        
        // If we hit this view itself (background), pass through
        if hitView == self {
            return nil
        }
        
        return hitView
    }
}

// Even simpler - just for a small floating view in a specific location:
final class FloatingOverlayView: UIView {
    private let contentView: UIView
    
    init(content: UIView, size: CGSize = CGSize(width: 200, height: 100)) {
        self.contentView = content
        super.init(frame: CGRect(origin: .zero, size: size))
        setup()
    }
    
    convenience init(swiftUIContent: some View, size: CGSize = CGSize(width: 200, height: 100)) {
        let hostingController = UIHostingController(rootView: AnyView(swiftUIContent))
        hostingController.view.backgroundColor = .clear
        self.init(content: hostingController.view, size: size)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        backgroundColor = UIColor.systemBackground.withAlphaComponent(0.9)
        layer.cornerRadius = 12
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowOpacity = 0.3
        layer.shadowRadius = 8
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(contentView)
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        ])
    }
    
    func show(in window: UIWindow? = nil, position: Position = .topTrailing) {
        guard let targetWindow = window ?? UIApplication.shared.windows.first else { return }
        
        targetWindow.addSubview(self)
        translatesAutoresizingMaskIntoConstraints = false
        
        let constraints: [NSLayoutConstraint]
        switch position {
        case .topLeading:
            constraints = [
                topAnchor.constraint(equalTo: targetWindow.safeAreaLayoutGuide.topAnchor, constant: 20),
                leadingAnchor.constraint(equalTo: targetWindow.leadingAnchor, constant: 20)
            ]
        case .topTrailing:
            constraints = [
                topAnchor.constraint(equalTo: targetWindow.safeAreaLayoutGuide.topAnchor, constant: 20),
                trailingAnchor.constraint(equalTo: targetWindow.trailingAnchor, constant: -20)
            ]
        case .center:
            constraints = [
                centerXAnchor.constraint(equalTo: targetWindow.centerXAnchor),
                centerYAnchor.constraint(equalTo: targetWindow.centerYAnchor)
            ]
        case .bottomTrailing:
            constraints = [
                bottomAnchor.constraint(equalTo: targetWindow.safeAreaLayoutGuide.bottomAnchor, constant: -20),
                trailingAnchor.constraint(equalTo: targetWindow.trailingAnchor, constant: -20)
            ]
        }
        
        NSLayoutConstraint.activate(constraints)
    }
    
    enum Position {
        case topLeading, topTrailing, center, bottomTrailing
    }
}
