//
//  ProductsView.swift
//  Rosovina
//
//  Created by Amir Ahmed on 04/11/2023.
//

import Foundation
import SwiftUI
import SDWebImageSwiftUI

struct ProductsSwiftUIView: View {
    
    @ObservedObject var viewModel: HomeViewModel
    
    @Binding var selectedProduct: Int
    var sectionName: String
    var products: [DynamicHomeModel]
    
    @Binding
    var viewMoreClicked: Bool
    
    @Binding
    var viewMoreItems: [DynamicHomeModel]
    
    @Binding
    var selectedViewMoreType: ViewMoreType?
    
    var body: some View {
        VStack {
            HStack{
                Text(sectionName)
                    .font(.poppinsFont(size: 14, weight: .semibold))
                    .foregroundColor(Color.black)
                Spacer()
                Text("view_more".localized)
                    .font(.poppinsFont(size: 10, weight: .semibold))
                    .foregroundColor(Color.black)
                    .onTapGesture {
                        self.viewMoreItems = products
                        self.selectedViewMoreType = .product
                        self.viewMoreClicked = true
                    }
            }
            
            ScrollView(.horizontal, showsIndicators: false){
                HStack{
                    ForEach(0..<products.count, id: \.self) { index in
                        ProductItem(viewModel: viewModel, product: products[index], selectedProductID: $selectedProduct).padding(.vertical,5)
                    }
                    
                    Spacer()
                }
            }
        }.padding(.horizontal, 15)
    }
}

struct ProductItem: View {
    
    @ObservedObject var viewModel: HomeViewModel
    @State var isAddedToWishList: Bool = false
    
    var product: DynamicHomeModel
    @Binding var selectedProductID: Int
    
    var body: some View {
        VStack {
            ZStack(alignment: .topTrailing){
                WebImage(url: URL(string: product.imagePath?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""))
                    .placeholder(Image("logo").resizable())
                    .resizable()
                    .indicator(.activity)
                    .scaledToFit()
                    .cornerRadius(4.0)
                    .frame(width: 140, height: 148)
                    .applyBlackAndWhite(isBlackAndWhite: product.isReadyForSale == 0)
                    .onTapGesture {
                        if product.isReadyForSale != 0 {
                            self.selectedProductID = product.id ?? 0
                        }
                    }
                
                if product.isReadyForSale == 0{
                    Text(product.isReadyForSaleText ?? "")
                        .font(.poppinsFont(size: 10, weight: .semibold))
                        .foregroundColor(.white)
                        .padding(.horizontal)
                        .padding(.vertical, 5)
                        .background(Color.red)
                        .cornerRadius(10)
                }
                
            }.frame(width: 130, height: 148)
            
            
            VStack(alignment: .leading, spacing: 4){
                Text(product.title ?? "")
                    .lineLimit(1)
                    .font(.poppinsFont(size: 10, weight: .regular))
                    .foregroundColor(Color.black)
                HStack{
                    HStack{
                        Text((product.currencyCode ?? "SAR".localized) + " " + String(product.price?.rounded() ?? 0))
                            .font(.poppinsFont(size: 14, weight: .bold))
                            .foregroundColor(Color.black)
//                        Text((product.currencyCode ?? "SAR") + " " + String(product.discountAmount ?? 0))
//                            .font(.poppinsFont(size: 8, weight: .medium))
//                            .foregroundColor(Color.gray)
//                            .strikethrough()
                        
                        Spacer()
                        
                        Image(self.isAddedToWishList ? "icons_like_blue" : "icons_like")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .onTapGesture {
                                self.isAddedToWishList.toggle()
                                product.addedToWishlist ?? false ? viewModel.removeItemFromWishlist(productID: product.id ?? 0) : viewModel.addItemToWishlist(productID: product.id ?? 0)
                            }
                        
                    }
                }
            }.onAppear{
                self.isAddedToWishList = product.addedToWishlist ?? false
            }
        }
        .frame(width: 150, height: 190)
        .padding(10)
        .multilineTextAlignment(.center)
        .cardBackground()
    }
}


// view modifier
struct CardBackground: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(Color.white)
            .cornerRadius(10)
            .shadow(color: Color.black.opacity(0.2), radius: 2)
    }
}

// view modifier
struct CardGrayBackground: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(Color("LightGray"))
            .cornerRadius(10)
            .shadow(color: Color.black.opacity(0.2), radius: 2)
    }
}

struct SuperCardGrayBackground: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(Color.white)
            .cornerRadius(15)
            .shadow(color: Color.gray.opacity(0.2), radius: 5)
    }
}

extension View {
    func cardBackground() -> some View {
        modifier(CardBackground())
    }
    
    func cardGrayBackground() -> some View {
        modifier(CardGrayBackground())
    }
    
    func superCardGrayBackground() -> some View {
        modifier(SuperCardGrayBackground())
    }
}


struct BlackAndWhite: ViewModifier {
    let isBlackAndWhite: Bool
    
    func body(content: Content) -> some View {
        if isBlackAndWhite {
            return AnyView(content
                            .colorMultiply(.white)
                            .saturation(0))
        } else {
            return AnyView(content)
        }
    }
}

extension View {
    func applyBlackAndWhite(isBlackAndWhite: Bool) -> some View {
        self.modifier(BlackAndWhite(isBlackAndWhite: isBlackAndWhite))
    }
}
