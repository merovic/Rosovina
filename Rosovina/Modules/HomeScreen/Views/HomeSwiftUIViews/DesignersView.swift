//
//  DesignersView.swift
//  Rosovina
//
//  Created by Amir Ahmed on 04/11/2023.
//

import Foundation
import SwiftUI

struct DesignersSwiftUIView: View {
    
    var imageNames = ["Plants", "Wedding", "Plants"]
    
    var body: some View {
        VStack {
            HStack{
                Text("Our Designers")
                    .font(.poppinsFont(size: 14, weight: .semibold))
                    .foregroundColor(Color.black)
                Spacer()
                Text("View More")
                    .font(.poppinsFont(size: 10, weight: .semibold))
                    .foregroundColor(Color.black)
            }
            
            ScrollView(.vertical, showsIndicators: false){
                VStack{
                    ForEach(0..<imageNames.count, id: \.self) { index in
                        DesignerItem().padding(.vertical, 10)
                    }
                }
            }
        }.padding(.horizontal, 15)
    }
}

struct DesignerItem: View {
    
    var body: some View {
        HStack(spacing: 20) {
            Image("Rectangle 32")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .cornerRadius(15)
                .frame(width: 67, height: 67)
            
            VStack(alignment: .leading, spacing: 10){
                Text("Sayed Abdul Hamid")
                    .font(.poppinsFont(size: 16, weight: .semibold))
                    .foregroundColor(Color.black)
                
                Text("Saudi Arabia")
                    .font(.poppinsFont(size: 14, weight: .medium))
                    .foregroundColor(Color.gray)
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(10)
        .cardBackground()
    }
}
