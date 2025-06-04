//
//  SearchableContentView.swift
//  UIKitTesting
//
//  Created by Ricky Witherspoon on 6/4/25.
//

import SwiftUI

struct SearchableContentView: View {
    @State private var show = false
    
    var body: some View {
        VStack {
            if show {
                ExpandingCircleView()
                    .onTapGesture {
                        show = false
                    }
            } else {
                Circle()
                    .foregroundStyle(.blue)
                    .frame(width: 50, height: 50)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                    .onTapGesture {
                        show.toggle()
                    }
            }
        }
        .border(Color.red)
    }
}

struct ExpandingCircleView: View {
    @State private var expand = false
    @State private var width: CGFloat = 50
    
    var body: some View {
        Circle()
            .foregroundStyle(Color.blue)
            .frame(width: width, height: width)
            .frame(
                maxWidth: .infinity,
                maxHeight: .infinity,
                alignment: expand ? . center : .bottomTrailing
            )
            .task {
                try? await Task.sleep(for: .seconds(1))
                
                withAnimation(.linear(duration: 3)) {
                    expand.toggle()
                    width = 200
                }
                
                try? await Task.sleep(for: .seconds(4))
                
                withAnimation(.linear(duration: 3)) {
                    width = 2200
                }
            }
            .border(Color.green)
    }
}

