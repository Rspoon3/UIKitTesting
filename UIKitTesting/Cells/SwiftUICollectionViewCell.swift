//
//  SwiftUICollectionViewCell.swift
//  UIKitTesting
//
//  Created by Richard Witherspoon on 1/5/23.
//

import SwiftUI


final class SwiftUICollectionViewCell<Content>: UICollectionViewCell where Content: View {
    
    /// Controller to host the SwiftUI View
    private(set) var host: UIHostingController<Content>?
    
    /// Add host controller to the heirarchy
    func configure(with content: Content, parent: UIViewController) {
        if let host {
            host.rootView = content
            host.view.layoutIfNeeded()
        } else {
            let host = UIHostingController(rootView: content)
            
            parent.addChild(host)
            host.didMove(toParent: parent)
            contentView.addSubview(host.view)
            
            self.host = host
        }
        
        host?.view.frame = contentView.bounds
    }
    
    // MARK: Controller + view clean up
    
    deinit {
        host?.willMove(toParent: nil)
        host?.view.removeFromSuperview()
        host?.removeFromParent()
        host = nil
    }
}
