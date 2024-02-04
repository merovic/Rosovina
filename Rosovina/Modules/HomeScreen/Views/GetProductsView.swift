//
//  GetProductsView.swift
//  Rosovina
//
//  Created by Amir Ahmed on 03/01/2024.
//

import UIKit
import SwiftUI
import SDWebImageSwiftUI
import Combine
import CombineCocoa

class GetProductsView: UIViewController {
    
    private var bindings = Set<AnyCancellable>()
    
    var viewModel: GetProductsViewModel?
    
    private let loadingView = LoadingAnimation()
    
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var container: UIView!

    @IBOutlet weak var categoryNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        BindViews()
        AttachViews()
    }
    
    func AttachViews() {
        self.container.EmbedSwiftUIView(view: GetProductsSwiftUIView(viewModel: self.viewModel!), parent: self)
    }
    
    func BindViews(){
        
        viewModel!.$isAnimating
            .receive(on: DispatchQueue.main)
            .assign(to: \.isVisible, on: loadingView)
            .store(in: &bindings)
        
        viewModel!.$categoryName
            .receive(on: DispatchQueue.main)
            .assign(to: \.text!, on: categoryNameLabel)
            .store(in: &bindings)
        
        viewModel!.$selectedProductID.sink { v in
            if v != 0{
                let newViewController = ProductDetailsView()
                newViewController.viewModel = ProductDetailsViewModel(productID: v)
                //newViewController.delegate = self
                self.navigationController?.pushViewController(newViewController, animated: true)
            }
        }.store(in: &bindings)
        
        backButton.tapPublisher
            .sink { _ in
                self.navigationController?.popViewController(animated: true)
            }
            .store(in: &bindings)
        
    }

}


struct GetProductsSwiftUIView: View {
    
    @ObservedObject var viewModel: GetProductsViewModel
    
    var body: some View {
        ZStack(alignment: .center){
            if self.viewModel.productItems.count > 0{
                ScrollView(.vertical, showsIndicators: false){
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 150))], spacing: 10) {
                        ForEach(self.viewModel.productItems) { item in
                            CategoryProductItem(viewModel: viewModel, product: item, selectedProductID: $viewModel.selectedProductID)
                        }
                    }
                }
            }else{
                VStack{
                    Text("Category is Empty")
                        .font(.poppinsFont(size: 25, weight: .medium))
                        .foregroundColor(Color.gray)
                    
                    Spacer().frame(height: 300)
                }
            }
        }
    }
}


struct CategoryProductItem: View {
    
    @ObservedObject var viewModel: GetProductsViewModel
    @State var isAddedToWishList: Bool = false
    
    var product: Product
    @Binding var selectedProductID: Int
    
    var body: some View {
        VStack {
            WebImage(url: URL(string: product.imagePath))
                .placeholder(Image("logo").resizable())
                .resizable()
                .indicator(.activity)
                .scaledToFit()
                .cornerRadius(4.0)
                .frame(width: 130, height: 148)
                .onTapGesture {
                    self.selectedProductID = product.id
                }
            
            VStack(alignment: .leading){
                Text(product.title)
                    .font(.poppinsFont(size: 10, weight: .regular))
                    .foregroundColor(Color.black)
                HStack{
                    HStack{
                        Text((product.currencyCode ?? "SAR") + " " + String(product.price.rounded()))
                            .font(.poppinsFont(size: 16, weight: .bold))
                            .foregroundColor(Color.black)
                        
                        Spacer()
                        
                        Image(isAddedToWishList ? "icons_like_blue" : "icons_like")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .onTapGesture {
                                self.isAddedToWishList.toggle()
                                product.addedToWishlist ?? false ? viewModel.removeItemFromWishlist(productID: product.id) : viewModel.addItemToWishlist(productID: product.id)
                            }
                    }
                }
            }.onAppear{
                self.isAddedToWishList = product.addedToWishlist ?? false
            }
            
        }
        .padding(10)
        .multilineTextAlignment(.center)
        .cardBackground()
    }
}
