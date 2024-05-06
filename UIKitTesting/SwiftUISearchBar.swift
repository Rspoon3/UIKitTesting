//
//  SwiftUISearchBar.swift
//  UIKitTesting
//
//  Created by Richard Witherspoon on 4/15/24.
//

import SwiftUI

struct SwiftUISearchBar: View {
    let searchController: UISearchController
    @State private var test = false
    @State private var text = ""
    @Namespace private var animation

    var body: some View {
        HStack {
                if test {
                    Button {
                        withAnimation {
                            searchController.isActive.toggle()
                            test = searchController.isActive
                            text.removeAll()
                        }
                    } label: {
                        Image(systemName: "chevron.left")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                            .matchedGeometryEffect(id: "Shape", in: animation)
                    }
                } else {
                    Image(systemName: "magnifyingglass")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                        .matchedGeometryEffect(id: "Shape", in: animation)
                }
                
                TextField("Search for something", text: $text)
                    .frame(height: 44)
                    .onSubmit {
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    }
            
            if !text.isEmpty {
                Button {
                    searchController.isActive = false
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
//                    text.removeAll()
                } label: {
                    Image(systemName: "xmark")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 18, height: 18)
                }
            }
            
//            Color.gray
//                .cornerRadius(44/2)
//                .overlay {
//                    Button("Press Me"){
//                        withAnimation {
//                            searchController.isActive.toggle()
//                            test = searchController.isActive
//                        }
//                    }
            //                }
        }
        .frame(height: 44)
        .padding(.horizontal, 16)
        .overlay {
            RoundedRectangle(cornerRadius: 44/2)
                .stroke()
        }
        .padding(.horizontal, 16)
        .onTapGesture {
            withAnimation {
                searchController.isActive = true
                test = searchController.isActive
            }
        }
        .onChange(of: text) { newValue in
//            print(newValue)
//            withAnimation {
//                searchController.isActive = !text.isEmpty
//                test = searchController.isActive
//            }
        }
    }
}

#Preview {
    SwiftUISearchBar(searchController: .init())
}
