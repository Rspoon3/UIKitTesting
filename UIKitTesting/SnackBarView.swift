//
//  SnackBarView.swift
//  UIKitTesting
//
//  Created by Richard Witherspoon on 11/1/23.
//

import SwiftUI

extension OfferReactionSnackBarView {
    final class ViewModel: ObservableObject {
        @Published var count = 1
    }
}

struct OfferReactionSnackBarView: View {
    @ObservedObject var viewModel: ViewModel
    let didTouch: ()-> Void
    
    var body: some View {
        HStack(spacing: 6) {
            Image("heart")
                .resizable()
                .frame(width: 20, height: 20)
            Text(viewModel.count.formatted())
                .animation(.interactiveSpring, value: viewModel.count)
                .monospaced()
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 18)
        .background {
            Capsule()
                .foregroundStyle(Color(red: 1, green: 232/255, blue: 247/255))
        }
        .overlay(
            Capsule()
                .stroke(
                    LinearGradient(
                        colors: [
                            Color(red: 236/255, green: 72/255, blue: 153/255),
                            Color(red: 189/255, green: 50/255, blue: 211/255)
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    ),
                    lineWidth: 2
                )
        )
        .onTapGesture {
            viewModel.count += 1
            didTouch()
        }
    }
}

#Preview {
    OfferReactionSnackBarView(viewModel: .init()) {
        
    }
}
