//
//  SliderView.swift
//  Rosovina
//
//  Created by Amir Ahmed on 09/02/2024.
//

import UIKit
import SwiftUI
import SDWebImageSwiftUI

class SliderView: UIViewController {

    @IBOutlet weak var container: UIView!
    var imageNames: [String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AttachViews()
    }
    
    func AttachViews() {
        self.container.EmbedSwiftUIView(view: SliderSwiftUIView(imageNames: imageNames!), parent: self)
    }

}

struct SliderSwiftUIView: View {
    
    var imageNames: [String]
    @State private var currentPage = 0
    
    var body: some View {
        VStack {
            TabView(selection: $currentPage) {
                ForEach(0..<imageNames.count, id: \.self) { index in
                    WebImage(url: URL(string:imageNames[index]))
                        .placeholder(Image("logo").resizable())
                        .resizable()
                        .indicator(.activity)
                        .scaledToFill()
                        .cornerRadius(4.0)
                        .frame(width: UIScreen.main.bounds.width - 50)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
            
            HStack(spacing: 10) {
                ForEach(0..<imageNames.count, id: \.self) { index in
                    Circle()
                        .frame(width: 8, height: 8)
                        .foregroundColor(index == currentPage ? Color("AccentColor") : .gray)
                }
            }
        }
    }
}
