//
//  GIFView.swift
//  UIKitTesting
//
//  Created by Richard Witherspoon on 1/5/23.
//

import SwiftUI
import FLAnimatedImage

struct GIFView: UIViewRepresentable {
    let image: FLAnimatedImage
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)
        let imageView = FLAnimatedImageView()
        
        imageView.animatedImage = image
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalTo: view.heightAnchor),
            imageView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])

        return view
      }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        print("Updating")
    }
}
