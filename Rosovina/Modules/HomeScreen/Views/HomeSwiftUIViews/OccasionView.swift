//
//  OccasionView.swift
//  Rosovina
//
//  Created by Amir Ahmed on 04/11/2023.
//

import Foundation
import SwiftUI
import SDWebImageSwiftUI

struct OccasionsSwiftUIView: View {
    
    var title: String
    var occasions: [DynamicHomeModel]
    
    @Binding
    var selectedCategory: DynamicHomeModel?
    
    var body: some View {
        VStack {
            HStack{
                Text(title)
                    .font(.poppinsFont(size: 14, weight: .semibold))
                    .foregroundColor(Color.black)
                Spacer()
                Text("View More")
                    .font(.poppinsFont(size: 10, weight: .semibold))
                    .foregroundColor(Color.black)
            }
            
            ScrollView(.horizontal, showsIndicators: false){
                HStack{
                    ForEach(0..<occasions.count, id: \.self) { index in
                        VStack(alignment: .center){
                            ZStack(alignment: .center){
                                if occasions[index].isOccasion == 1{
                                    Circle()
                                        .fill(.white)
                                        .frame(width: 60, height: 60)
                                }else{
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color("DarkRed"))
                                        .frame(width: 61, height: 61)
                                }
                                
                                WebImage(url: URL(string: occasions[index].thumbURL ?? ""))
                                    .placeholder(Image("jacket").resizable())
                                    .resizable()
                                    .indicator(.activity)
                                    .scaledToFit()
                                    .frame(width: 32, height: 32)
                            }
                            
                            Text(occasions[index].title ?? "")
                                .lineLimit(nil)
                                .multilineTextAlignment(.center)
                                .font(.poppinsFont(size: 10, weight: .regular))
                                .foregroundColor(Color.black)
                                .frame(width: 60, height: 28)
                        }.padding(5)
                            .onTapGesture {
                                self.selectedCategory = self.occasions[index]
                            }
                    }
                    
                    Spacer()
                }
            }
        }.padding(.horizontal, 15)
    }
}
