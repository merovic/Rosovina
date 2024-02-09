//
//  HomeViewController.swift
//  Rosovina
//
//  Created by Amir Ahmed on 04/11/2023.
//

import UIKit
import SwiftUI
import Combine
import SDWebImageSwiftUI

class HomeViewController: UIViewController {
    
    private var bindings = Set<AnyCancellable>()
    
    var viewModel: HomeViewModel = HomeViewModel()
    
    private let loadingView = LoadingAnimation()

    @IBOutlet weak var cartButton: UIButton!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var cartBadge: UILabel! {
        didSet {
            cartBadge.layer.cornerRadius = CGRectGetWidth(cartBadge.frame)/2
            cartBadge.layer.masksToBounds = true
        }
    }
    
    @IBOutlet weak var notificationsButton: UIButton!
    
    @IBOutlet weak var container: UIView! { didSet { container.layer.cornerRadius = 25.0}}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
        AttachViews()
        BindViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.viewModel.home()
    }
    
    func AttachViews() {
        self.container.EmbedSwiftUIView(view: HomeSwiftUIView(viewModel: self.viewModel), parent: self)
    }
    
    func BindViews(){
        viewModel.$isAnimating
            .receive(on: DispatchQueue.main)
            .assign(to: \.isVisible, on: loadingView)
        .store(in: &bindings)
        
        cartButton.tapPublisher
            .sink { _ in
                let newViewController = ShoppingCartView()
                self.navigationController?.pushViewController(newViewController, animated: true)
            }
            .store(in: &bindings)
        
        searchButton.tapPublisher
            .sink { _ in
                let newViewController = SearchView()
                self.navigationController?.pushViewController(newViewController, animated: true)
            }
            .store(in: &bindings)
        
        notificationsButton.tapPublisher
            .sink { _ in
                if LoginDataService.shared.isLogedIn(){
                    let newViewController = NotificationsView()
                    self.navigationController?.pushViewController(newViewController, animated: true)
                }else {
                    let newViewController = NeedLoginView()
                    newViewController.showBackButton = true
                    self.navigationController?.pushViewController(newViewController, animated: true)
                }
            }
            .store(in: &bindings)
        
        viewModel.$badgeCount
            .receive(on: DispatchQueue.main)
            .assign(to: \.text!, on: cartBadge)
            .store(in: &bindings)
        
        viewModel.$badgeCount.sink { v in
            if v != "0"{
                self.cartBadge.isHidden = false
            }
        }.store(in: &bindings)
        
        viewModel.$selectedProduct.sink { v in
            if v != 0{
                let newViewController = ProductDetailsView()
                newViewController.viewModel = ProductDetailsViewModel(productID: v)
                newViewController.delegate = self
                self.navigationController?.pushViewController(newViewController, animated: true)
            }
        }.store(in: &bindings)
        
        viewModel.$selectedCategory.sink { v in
            if v != nil{
                let newViewController = GetProductsView()
                newViewController.viewModel = GetProductsViewModel(productType: ((v?.isOccasion) != nil) ? .occation : .category, typeName: v?.title ?? "", typeID: v?.id ?? 0)
                self.navigationController?.pushViewController(newViewController, animated: true)
            }
        }.store(in: &bindings)
        
        viewModel.$viewMoreProductsClicked.sink { v in
            if v {
                let newViewController = ViewMoreView()
                newViewController.viewModel = ViewMoreViewModel(viewMoreItems: self.viewModel.selectedViewMoreItems, viewMoreType: self.viewModel.selectedViewMoreType ?? .product)
                self.navigationController?.pushViewController(newViewController, animated: true)
            }
        }.store(in: &bindings)
        
        viewModel.$viewMoreCategoriesClicked.sink { v in
            if v {
                let newViewController = ViewMoreView()
                newViewController.viewModel = ViewMoreViewModel(viewMoreItems: self.viewModel.selectedViewMoreItems, viewMoreType: self.viewModel.selectedViewMoreType ?? .product)
                self.navigationController?.pushViewController(newViewController, animated: true)
            }
        }.store(in: &bindings)
    }

}

extension HomeViewController: CartDelegate {
    func cartAssigned(quantity: Int) {
        if quantity != 0{
            self.cartBadge.isHidden = false
            self.cartBadge.text = String(quantity)
        }else{
            self.cartBadge.isHidden = true
        }
    }
}


struct HomeSwiftUIView: View {
    
    @ObservedObject var viewModel: HomeViewModel
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false){
            VStack(spacing: 15) {
                
                Spacer().frame(height: 15)
                
                ForEach(self.viewModel.sections) { section in
                    switch section.code{
                    case .slider:
                        // MARK: - Slider
                        ImageCarouselView(data: section.data)
                            .frame(height: 200)
//                        SnapCarousel(items: section.data)
//                            .environmentObject(ContentViewModel().stateModel)
//                            .frame(height: 120)
                    case .occasionCategories:
                        // MARK: - Occasions
                        OccasionsSwiftUIView(title: section.title, occasions: section.data, selectedCategory: $viewModel.selectedCategory, viewMoreClicked: $viewModel.viewMoreCategoriesClicked, viewMoreItems: $viewModel.selectedViewMoreItems, selectedViewMoreType: $viewModel.selectedViewMoreType)
                    case .categories:
                        // MARK: - Categories
                        OccasionsSwiftUIView(title: section.title, occasions: section.data, selectedCategory: $viewModel.selectedCategory, viewMoreClicked: $viewModel.viewMoreCategoriesClicked, viewMoreItems: $viewModel.selectedViewMoreItems, selectedViewMoreType: $viewModel.selectedViewMoreType)
                    case .featuredProducts:
                        // MARK: - Featured products
                        ProductsSwiftUIView(viewModel: viewModel, selectedProduct: $viewModel.selectedProduct, sectionName: section.title, products: section.data, viewMoreClicked: $viewModel.viewMoreProductsClicked, viewMoreItems: $viewModel.selectedViewMoreItems, selectedViewMoreType: $viewModel.selectedViewMoreType)
                    case .advertise:
                        // MARK: - Advertise
                        WebImage(url: URL(string: section.data[0].imagePath ?? ""))
                            .placeholder(Image("Banner 1").resizable())
                            .resizable()
                            .indicator(.activity)
                            .frame(height: 145)
                            .padding(.horizontal)
                        // MARK: - Popular products
                    case .popularProducts:
                        ProductsSwiftUIView(viewModel: viewModel, selectedProduct: $viewModel.selectedProduct, sectionName: section.title, products: section.data, viewMoreClicked: $viewModel.viewMoreProductsClicked, viewMoreItems: $viewModel.selectedViewMoreItems, selectedViewMoreType: $viewModel.selectedViewMoreType)
                    }
                }
                
                // MARK: - Designers
                //DesignersSwiftUIView()
                
                Spacer()
            }
        }
    }
}
