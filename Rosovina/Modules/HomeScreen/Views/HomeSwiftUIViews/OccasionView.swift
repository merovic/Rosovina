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
    
    @Binding
    var viewMoreClicked: Bool
    
    @Binding
    var viewMoreItems: [DynamicHomeModel]
    
    @Binding
    var selectedViewMoreType: ViewMoreType?
    
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
                    .onTapGesture {
                        self.viewMoreItems = occasions
                        self.selectedViewMoreType = title == "Brands" ? .brand : (occasions[0].isOccasion == 1 ? .occation : .category)
                        self.viewMoreClicked = true
                    }
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
                                        .fill(Color.white)
                                        .frame(width: 100, height: 100)
                                    
//                                    RoundedRectangle(cornerRadius: 10)
//                                        .fill(Color("DarkRed"))
//                                        .frame(width: 61, height: 61)
                                }
                                
                                WebImage(url: URL(string: occasions[index].imagePath ?? ""))
                                    //.placeholder(Image("jacket").resizable())
                                    .resizable()
                                    .indicator(.activity)
                                    .scaledToFit()
                                    .cornerRadius(10)
                                    .frame(width: occasions[index].isOccasion == 1 ? 32 : 90, height: occasions[index].isOccasion == 1 ? 32 : 90)
                            }
                            
                            Text((occasions[index].title ?? occasions[index].name) ?? "")
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
