//
//  BlogView.swift
//  Rosovina
//
//  Created by Amir Ahmed on 11/11/2023.
//

import UIKit
import SwiftUI
import SDWebImageSwiftUI

class BlogView: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

}

struct BlogsSwiftUIView: View {
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false){
            BlogsItemSwiftUIView()
            BlogsItemSwiftUIView()
            BlogsItemSwiftUIView()
            BlogsItemSwiftUIView()
        }
        
    }
    
}


struct BlogsItemSwiftUIView: View {
    
    var body: some View {
        VStack(alignment: .leading){
            WebImage(url: URL(string: ""))
                //.placeholder(Image("flower5").resizable())
                .resizable()
                .indicator(.activity)
                .scaledToFit()
                .cornerRadius(10)
                .frame(width: .infinity, height: 190)
            
            Text("10 reason why everyday mosturizing matters")
                .lineLimit(nil)
                .multilineTextAlignment(.center)
                .font(.poppinsFont(size: 20, weight: .bold))
                .padding()
                .foregroundColor(.black)
            
            HStack{
                Image("")
                    .resizable()
                    .frame(width: 27, height: 27)
                
                Text("Anastasia")
                    .font(.poppinsFont(size: 16, weight: .medium))
                    .foregroundColor(.black)
            }
                        
        }.background(.gray)
            .cornerRadius(12)
        
    }
    
}
