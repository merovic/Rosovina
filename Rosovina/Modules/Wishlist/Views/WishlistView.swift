//
//  WishlistView.swift
//  Rosovina
//
//  Created by Amir Ahmed on 11/11/2023.
//

import UIKit
import SwiftUI
import SDWebImageSwiftUI
import Combine
import CombineCocoa

class WishlistView: UIViewController {
    
    private var bindings = Set<AnyCancellable>()
    
    var viewModel: WishlistViewModel = WishlistViewModel()
    
    private let loadingView = LoadingAnimation()
    
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var container: UIView!

    var showBackButton: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        BindViews()
        AttachViews()
        if showBackButton != nil{
            backButton.isHidden = false
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        self.viewModel.getWishlist()
    }
    
    func AttachViews() {
        self.container.EmbedSwiftUIView(view: WishlistSwiftUIView(viewModel: self.viewModel), parent: self)
    }
    
    func BindViews(){
        
        viewModel.$isAnimating
            .receive(on: DispatchQueue.main)
            .assign(to: \.isVisible, on: loadingView)
            .store(in: &bindings)
        
        backButton.tapPublisher
            .sink { _ in
                self.navigationController?.popViewController(animated: true)
            }
            .store(in: &bindings)
        
        viewModel.$selectedProductID.sink { v in
            if v != 0{
                let newViewController = ProductDetailsView()
                newViewController.viewModel = ProductDetailsViewModel(productID: v)
                //newViewController.delegate = self
                self.navigationController?.pushViewController(newViewController, animated: true)
            }
        }.store(in: &bindings)
    }

}


struct WishlistSwiftUIView: View {
    
    @ObservedObject var viewModel: WishlistViewModel
    
    var body: some View {
        ZStack(alignment: .center){
            if self.viewModel.wishlistItems.count > 0{
                ScrollView(.vertical, showsIndicators: false){
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 150))], spacing: 10) {
                        ForEach(self.viewModel.wishlistItems) { item in
                            WishlistProductItem(viewModel: viewModel, product: item)
                        }
                    }
                }
            }else{
                VStack{
                    Text("Wishlist is Empty")
                        .font(.poppinsFont(size: 25, weight: .medium))
                        .foregroundColor(Color.gray)
                    
                    Spacer().frame(height: 300)
                }
            }
        }
    }
}


struct WishlistProductItem: View {
    
    @ObservedObject var viewModel: WishlistViewModel
    
    var product: WishlistItem
    
    var body: some View {
        VStack {
            WebImage(url: URL(string: product.productImage))
                .placeholder(Image("logo").resizable())
                .resizable()
                .indicator(.activity)
                .scaledToFit()
                .cornerRadius(4.0)
                .frame(width: 130, height: 148)
                .onTapGesture {
                    self.viewModel.selectedProductID = product.productID
                }
            
            VStack(alignment: .leading){
                Text(product.productName)
                    .font(.poppinsFont(size: 10, weight: .regular))
                    .foregroundColor(Color.black)
                HStack{
                    HStack{
                        Text((product.currencyCode ?? "SAR") + " " + String(product.price.rounded()))
                            .font(.poppinsFont(size: 16, weight: .bold))
                            .foregroundColor(Color.black)
                        
                        Spacer()
                        
                        Image("icons_like_blue")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .onTapGesture {
                                viewModel.removeItemFromWishlist(productID: product.productID)
                            }
                    }
                }
            }
            
        }
        .padding(10)
        .multilineTextAlignment(.center)
        .cardBackground()
    }
}
