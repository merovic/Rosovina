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
import SDWebImage
import BottomSheet

class HomeViewController: UIViewController {
    
    private var bindings = Set<AnyCancellable>()
    
    var viewModel: HomeViewModel = HomeViewModel()
    
    private let loadingView = LoadingAnimation()
    
    var cityGest: UITapGestureRecognizer = {
        let gest = UITapGestureRecognizer()
        gest.numberOfTapsRequired = 1
        return gest
    }()
    
    @IBOutlet weak var cityStackView: UIStackView! {
        didSet {
            cityStackView.isUserInteractionEnabled = true
            cityStackView.addGestureRecognizer(cityGest)
        }
    }
    
    @IBOutlet weak var flagImage: UIImageView!

    @IBOutlet weak var cityName: UILabel! {
        didSet {
            cityName.text = LoginDataService.shared.getUserCity().name
        }
    }
    
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleFavoriteStatusChanged(_:)), name: .favoriteStatusChanged, object: nil)
    }
    
    @objc func handleFavoriteStatusChanged(_ notification: Notification) {
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
        
        cityGest.tapPublisher
            .sink(receiveValue:{_ in
                let vc = CitySelectorView(initialHeight: 1000)
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
        
        viewModel.$selectedSliderImage.sink { v in
            if v != nil{
                let newViewController = GetProductsView()
                newViewController.viewModel = GetProductsViewModel(productType: .category, typeName: v!.title ?? "", typeID: v?.id ?? 0)
                self.navigationController?.pushViewController(newViewController, animated: true)
            }
        }.store(in: &bindings)
        
        viewModel.$selectedCategory.sink { v in
            if v != nil{
                let newViewController = GetProductsView()
                newViewController.viewModel = GetProductsViewModel(productType: v!.isBrand != nil ? .brand : v!.isOccasion != nil ? .occation : .category, typeName: (v?.title ?? v?.name) ?? "", typeID: v?.id ?? 0)
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

extension HomeViewController: CitySelectorBottomSheetDelegate {
    func clickAssigned(selectedCountry: GeoLocationAPIResponseElement, selectedCity: GeoLocationAPIResponseElement) {
        LoginDataService.shared.setUserCountry(country: selectedCountry)
        LoginDataService.shared.setUserCity(city: selectedCity)
        self.flagImage.sd_setImage(with: URL(string: selectedCountry.image_path ?? ""), placeholderImage: UIImage(named: "placeholder.png"))
        self.cityName.text = selectedCity.name
        self.viewModel.home()
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
                    case .slider, .sliderAds:
                        // MARK: - Slider
                        ImageCarouselView(data: section.data, selectedSliderImage: $viewModel.selectedSliderImage)
                            .frame(height: 200)
                    case .occasionCategories:
                        // MARK: - Occasions
                        OccasionsSwiftUIView(title: section.title, occasions: section.data, selectedCategory: $viewModel.selectedCategory, viewMoreClicked: $viewModel.viewMoreCategoriesClicked, viewMoreItems: $viewModel.selectedViewMoreItems, selectedViewMoreType: $viewModel.selectedViewMoreType)
                    case .categories:
                        // MARK: - Categories
                        OccasionsSwiftUIView(title: section.title, occasions: section.data, selectedCategory: $viewModel.selectedCategory, viewMoreClicked: $viewModel.viewMoreCategoriesClicked, viewMoreItems: $viewModel.selectedViewMoreItems, selectedViewMoreType: $viewModel.selectedViewMoreType)
                    case .brands:
                        // MARK: - brands
                        OccasionsSwiftUIView(title: section.title, occasions: section.data, selectedCategory: $viewModel.selectedCategory, viewMoreClicked: $viewModel.viewMoreCategoriesClicked, viewMoreItems: $viewModel.selectedViewMoreItems, selectedViewMoreType: $viewModel.selectedViewMoreType)
                    case .featuredProducts, .newArrival:
                        // MARK: - Featured products
                        ProductsSwiftUIView(viewModel: viewModel, selectedProduct: $viewModel.selectedProduct, sectionName: section.title, products: section.data, viewMoreClicked: $viewModel.viewMoreProductsClicked, viewMoreItems: $viewModel.selectedViewMoreItems, selectedViewMoreType: $viewModel.selectedViewMoreType)
                    case .advertise:
                        // MARK: - Advertise
                        WebImage(url: URL(string: section.data[0].imagePath ?? ""))
                            .placeholder(Image("Banner 1").resizable())
                            .resizable()
                            .indicator(.activity)
                            .frame(height: 160)
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
