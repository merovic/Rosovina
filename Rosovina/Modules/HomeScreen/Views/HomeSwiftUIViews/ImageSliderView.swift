//
//  File.swift
//  Rosovina
//
//  Created by Amir Ahmed on 04/11/2023.
//

import SwiftUI

struct ImageSliderView: View {
    var imageNames = ["image1", "image2", "image3"] // Replace with your image names
    @State private var currentPage = 0
    @State private var offset: CGFloat = 0

    var body: some View {
        GeometryReader { geometry in
            VStack {
                ZStack {
                    TabView(selection: $currentPage) {
                        ForEach(0..<imageNames.count, id: \.self) { index in
                            Image(imageNames[index])
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: geometry.size.width - 100, height: geometry.size.height)
                                .offset(x: CGFloat(index - currentPage) * (geometry.size.width - 100) + offset)
                        }
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                    .gesture(DragGesture()
                        .onChanged { value in
                            offset = value.translation.width
                        }
                        .onEnded { value in
                            let changeInX = -value.translation.width
                            let newPage = (changeInX > 50) ? max(currentPage - 1, 0) : (changeInX < -50) ? min(currentPage + 1, imageNames.count - 1) : currentPage
                            withAnimation {
                                currentPage = newPage
                                offset = 0
                            }
                        }
                    )

                    HStack {
                        ForEach(0..<imageNames.count, id: \.self) { index in
                            Circle()
                                .frame(width: 8, height: 8)
                                .foregroundColor(index == currentPage ? .black : .gray)
                        }
                    }
                    .padding(.bottom, 20)
                }
            }
        }
    }
}

struct ImageSliderView_Previews: PreviewProvider {
    static var previews: some View {
        ImageSliderView()
    }
}
