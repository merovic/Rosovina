//
//  ViewMoreView.swift
//  Rosovina
//
//  Created by Amir Ahmed on 08/02/2024.
//

import UIKit
import SwiftUI
import SDWebImageSwiftUI
import Combine
import CombineCocoa

class ViewMoreView: UIViewController {
    
    private var bindings = Set<AnyCancellable>()
    
    var viewModel: ViewMoreViewModel?
    
    private let loadingView = LoadingAnimation()
    
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var container: UIView!

    @IBOutlet weak var typeNameLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        AttachViews()
        BindViews()
    }
    
    func AttachViews() {
        self.container.EmbedSwiftUIView(view: ViewMoreSwiftUIView(viewModel: self.viewModel!), parent: self)
    }
    
    func BindViews(){
        
        viewModel!.$isAnimating
            .receive(on: DispatchQueue.main)
            .assign(to: \.isVisible, on: loadingView)
            .store(in: &bindings)
        
        backButton.tapPublisher
            .sink { _ in
                self.navigationController?.popViewController(animated: true)
            }
            .store(in: &bindings)
        
        viewModel!.$categoryName
            .receive(on: DispatchQueue.main)
            .assign(to: \.text!, on: typeNameLabel)
            .store(in: &bindings)
        
        viewModel!.$selectedProductID.sink { v in
            if v != 0{
                let newViewController = ProductDetailsView()
                newViewController.viewModel = ProductDetailsViewModel(productID: v)
                //newViewController.delegate = self
                self.navigationController?.pushViewController(newViewController, animated: true)
            }
        }.store(in: &bindings)
        
        viewModel!.$selectedCategory.sink { v in
            if v != nil{
                let newViewController = GetProductsView()
                newViewController.viewModel = GetProductsViewModel(productType: v!.isBrand != nil ? .brand : v!.isOccasion != nil ? .occation : .category, typeName: v?.title ?? "", typeID: v?.id ?? 0)
                self.navigationController?.pushViewController(newViewController, animated: true)
            }
        }.store(in: &bindings)
        
    }
}

struct ViewMoreSwiftUIView: View {
    
    @ObservedObject var viewModel: ViewMoreViewModel
    
    var body: some View {
        if viewModel.viewMoreType != .product {
            ZStack(alignment: .center){
                if self.viewModel.viewMoreItems.count > 0{
                    ScrollView(.vertical, showsIndicators: false){
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: viewModel.viewMoreType == .occation ? 100 : 150))], spacing: 10) {
                            ForEach(self.viewModel.viewMoreItems) { item in
                                VStack(alignment: .center){
                                    ZStack(alignment: .center){
                                        if item.isOccasion == 1{
                                            Circle()
                                                .fill(.white)
                                                .frame(width: 60, height: 60)
                                        }else{
                                            RoundedRectangle(cornerRadius: 10)
                                                .fill(Color.white)
                                                .frame(width: 100, height: 100)
                                        }
                                        
                                        WebImage(url: URL(string: item.imagePath?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""))
                                            .resizable()
                                            .indicator(.activity)
                                            .scaledToFit()
                                            .cornerRadius(10)
                                            .frame(width: item.isOccasion == 1 ? 32 : 90, height: item.isOccasion == 1 ? 32 : 90)
                                    }
                                    
                                    Text(item.title ?? "")
                                        .lineLimit(nil)
                                        .multilineTextAlignment(.center)
                                        .font(.poppinsFont(size: 10, weight: .regular))
                                        .foregroundColor(Color.black)
                                        .frame(width: 60, height: 28)
                                }.padding(5)
                                    .onTapGesture {
                                        self.viewModel.selectedCategory = item
                                    }
                            }
                        }
                    }
                }else{
                    VStack{
                        Text("List is Empty")
                            .font(.poppinsFont(size: 25, weight: .medium))
                            .foregroundColor(Color.gray)
                        
                        Spacer().frame(height: 300)
                    }
                }
            }
        }else{
            ZStack(alignment: .center){
                if self.viewModel.viewMoreItems.count > 0{
                    ScrollView(.vertical, showsIndicators: false){
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 150))], spacing: 10) {
                            ForEach(self.viewModel.viewMoreItems) { product in
                                VStack {
                                    WebImage(url: URL(string: product.imagePath?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""))
                                        .placeholder(Image("logo").resizable())
                                        .resizable()
                                        .indicator(.activity)
                                        .scaledToFit()
                                        .cornerRadius(4.0)
                                        .frame(width: 130, height: 148)
                                    
                                    VStack(alignment: .leading){
                                        Text(product.title ?? "")
                                            .lineLimit(1)
                                            .font(.poppinsFont(size: 10, weight: .regular))
                                            .foregroundColor(Color.black)
                                        HStack{
                                            HStack{
                                                Text((product.currencyCode ?? "SAR") + " " + String(product.price?.rounded() ?? 0))
                                                    .font(.poppinsFont(size: 14, weight: .bold))
                                                    .foregroundColor(Color.black)
//                                                Text((product.currencyCode ?? "SAR") + " " + String((product.discountAmount ?? 0)))
//                                                    .font(.poppinsFont(size: 8, weight: .medium))
//                                                    .foregroundColor(Color.gray)
//                                                    .strikethrough()
                                                
                                                Spacer()
                                                
                                            }
                                        }
                                    }
                                }
                                .frame(height: 180)
                                .padding(10)
                                .multilineTextAlignment(.center)
                                .cardBackground()
                                .onTapGesture{
                                    self.viewModel.selectedProductID = product.id!
                                }
                            }
                        }
                    }
                }else{
                    VStack{
                        Text("List is Empty")
                            .font(.poppinsFont(size: 25, weight: .medium))
                            .foregroundColor(Color.gray)
                        
                        Spacer().frame(height: 300)
                    }
                }
            }
        }
    }
}
