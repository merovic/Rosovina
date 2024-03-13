//
//  SearchView.swift
//  Rosovina
//
//  Created by Amir Ahmed on 20/01/2024.
//

import UIKit
import SwiftUI
import SDWebImageSwiftUI
import Combine
import CombineCocoa
import BottomSheet

class SearchView: UIViewController, UITextFieldDelegate {

    private var bindings = Set<AnyCancellable>()
    
    var viewModel: SearchViewModel = SearchViewModel()
    
    private let loadingView = LoadingAnimation()
    
    @IBOutlet weak var searchView: UIView! {
        didSet {
            searchView.roundedGrayHareefView()
        }
    }
    @IBOutlet weak var searchTextField: UITextField! {
        didSet {
            searchTextField.delegate = self
        }
    }
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var container: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        BindViews()
        AttachViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchTextField.becomeFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        self.viewModel.getProductsBySearch()
        return false
    }
    
    func AttachViews() {
        self.container.EmbedSwiftUIView(view: GetProductsForSearchSwiftUIView(viewModel: self.viewModel), parent: self)
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
        
        searchTextField.textPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.searchText, on: viewModel)
        .store(in: &bindings)
        
        viewModel.$selectedProductID.sink { v in
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
        
        filterButton.tapPublisher
            .sink(receiveValue:{_ in //600
                let vc = FilterView(initialHeight: 600)
                vc.delegate = self
                self.presentBottomSheetInsideNavigationController(
                    viewController: vc,
                    configuration: BottomSheetConfiguration(
                        cornerRadius: 20,
                        pullBarConfiguration: .visible(.init(height: 20)),
                        shadowConfiguration: .init(backgroundColor: UIColor.black.withAlphaComponent(0.6))
                    )
                )
            })
            .store(in: &bindings)
        
    }

}

extension SearchView: FilterDelegate {
    func filterAssigned(categories: [Int], priceRange: [Int], brands: [Int], rating: [Int]) {
        self.viewModel.filterObject = Filter(occassions: categories, price: priceRange, brands: brands, rating: rating)
        self.viewModel.getProductsByFilter()
    }
}

struct GetProductsForSearchSwiftUIView: View {
    
    @ObservedObject var viewModel: SearchViewModel
    
    var body: some View {
        ZStack(alignment: .center){
            if self.viewModel.productItems.count > 0{
                ScrollView(.vertical, showsIndicators: false){
                    VStack{
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 150))], spacing: 10) {
                            ForEach(self.viewModel.productItems.indices, id: \.self) { index in
                                SearchProductItem(viewModel: viewModel, product: self.viewModel.productItems[index], selectedProductID: $viewModel.selectedProductID)
                                    .onAppear(perform: {
                                        if index == viewModel.productItems.count - 1 {
                                            if viewModel.productsListFull == false {
                                                if viewModel.filterObject != nil {
                                                    viewModel.getProductsByFilter()
                                                }else{
                                                    viewModel.getProductsBySearch()
                                                }
                                            }
                                        }
                                    })
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

struct SearchProductItem: View {
    
    @ObservedObject var viewModel: SearchViewModel
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
