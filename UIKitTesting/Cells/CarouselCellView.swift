//
//  CarouselCellView.swift
//  UIKitTesting
//
//  Created by Richard Witherspoon on 1/5/23.
//

import SwiftUI
import FLAnimatedImage

struct CarouselCellView: View {
    private let cornerRadius: CGFloat = 8
    let gifData = try! Data(contentsOf: Bundle.main.url(forResource: "slideGif", withExtension: "gif")!)
    private let testOpactiy: Double = 1
    let info: CellInfo
    
    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .top) {
                if info.index.isMultiple(of: 4) && info.showGif {
                    GIFView(data: gifData)
                        .cornerRadius(cornerRadius)
                        .padding(.top, 36)
                        .padding(.horizontal, 40)
                        .blur(radius: 20)
                    
                    GIFView(data: gifData)
                        .cornerRadius(cornerRadius)
                        .padding(.bottom, 4)
                        .opacity(testOpactiy)
                } else {
                    Image(info.imageTitle)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: (geo.size.width / 2) - 36 + 4)
                        .clipped()
                        .padding(.top, 36)
                        .padding(.horizontal, 40)
                        .cornerRadius(cornerRadius)
                        .blur(radius: 20)
                    
                    Image(info.imageTitle)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: geo.size.width / 2)
                        .cornerRadius(cornerRadius)
                        .clipped()
                        .opacity(testOpactiy)
                }
                
                if let text = info.cellType?.rawValue {
                    Text(text)
                }
            }
        }
    }
}

