//
//  CarouselCellView.swift
//  UIKitTesting
//
//  Created by Richard Witherspoon on 1/5/23.
//

import SwiftUI
import FLAnimatedImage

struct CarouselCellView: View {
    private let scale = 0.88
    private let cornerRadius: CGFloat = 8
    private let testOpactiy: Double = 1
    let info: CellInfo
    @State private var image: FLAnimatedImage?
    
    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .bottom) {
                if let image, let posterImage = image.posterImage, info.index.isMultiple(of: 4) && info.showGif {
                    Image(uiImage: posterImage)
                        .resizable()
                        .cornerRadius(cornerRadius)
                        .aspectRatio(contentMode: .fill)
                        .frame(
                            width: geo.size.width * scale,
                            height: geo.size.width * scale / 2
                        )
                        .border(Color.black)
                        .clipped()
                        .padding(.bottom, -4)
                        .blur(radius: 15)
                    
                    GIFView(image: image)
                        .cornerRadius(cornerRadius)
                        .opacity(testOpactiy)
                        .frame(height: geo.size.width  / 2)
                } else {
                    Image(info.imageTitle)
                        .resizable()
                        .cornerRadius(cornerRadius)
                        .aspectRatio(contentMode: .fill)
                        .frame(
                            width: geo.size.width * scale,
                            height: geo.size.width * scale / 2
                        )
                        .clipped()
                        .padding(.bottom, -4)
                        .blur(radius: 15)
                    
                    Image(info.imageTitle)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: geo.size.width / 2)
                        .cornerRadius(cornerRadius)
                        .clipped()
                        .opacity(testOpactiy)
                }
            }
        }
        .task {
            try? await download()
        }
    }
    
    private func download() async throws {
        let url = URL(string: "https://cdn.staging-images.fetchrewards.com/carousels/38376a7ce028e5ba94fb51c85ced5e8f13c47399.gif")!
        let (data, _) = try await URLSession.shared.data(from: url)
        image = .init(gifData: data)
    }
}



struct CarouselCellView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(["iPhone 14", "iPad Air (5th generation)"], id: \.self) { name in
            GeometryReader { geo in
                VStack {
                    CarouselCellView(info: .init(index: 0, showGif: true, cellType: .swiftui, imageTitle: "test"))
                        .padding()
                    
                    CarouselCellView(info: .init(index: 0, showGif: false, cellType: .swiftui, imageTitle: "Slide-4"))
                        .padding()
                }
            }
            .previewDevice(.init(stringLiteral: name))
        }
    }
}
