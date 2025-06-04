//
//  FullscreenOverlayWrapper.swift
//  UIKitTesting
//
//  Created by Ricky Witherspoon on 6/4/25.
//

import SwiftUI

struct FullscreenOverlayWrapper<Overlay: View>: View {
    let overlay: () -> Overlay
    
    init(@ViewBuilder overlay: @escaping () -> Overlay) {
        self.overlay = overlay
    }
    
    var body: some View {
        Color.clear
            .onAppear {
                print("Hello")
                FullscreenOverlay.shared.show {
                    overlay()
                }
            }
            .onDisappear {
                print("Goodbye")
                FullscreenOverlay.shared.dismiss()
            }
    }
}
