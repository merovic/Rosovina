//
//  HomeViewModel.swift
//  Rosovina
//
//  Created by Amir Ahmed on 29/12/2023.
//

import Foundation
import Combine
import Firebase

class HomeViewModel: ObservableObject {
    
    private var cancellables: Set<AnyCancellable> = []
    
    //---------------------
    
    @Published var sections: [Section] = []
    
    @Published var selectedProduct = 0
    
    @Published var badgeCount = "0"
    
    @Published var selectedCity: GeoLocationAPIResponseElement = LoginDataService.shared.getUserCity()
    
    @Published var selectedCategory: DynamicHomeModel?
    
    @Published var selectedViewMoreType: ViewMoreType?
    
    @Published var selectedViewMoreItems: [DynamicHomeModel] = []
    
    @Published var viewMoreCategoriesClicked = false
    
    @Published var viewMoreProductsClicked = false
                        
    @Published var isAnimating = false
    
    let token = UIDevice.current.identifierForVendor!.uuidString
        
    //---------------------
        
    let dataService: HomeService
    let wishListService: WishlistService
    
    init(dataService: HomeService = AppHomeService(), wishListService: WishlistService = AppWishlistService()) {
        self.dataService = dataService
        self.wishListService = wishListService
        self.home()
    }
    
    func home() {
        
        self.isAnimating = true

        dataService.home(deviceToken: token, cityID: LoginDataService.shared.getUserCity().id)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { (completion) in
                    switch completion {
                    case .finished:
                        print("Publisher stopped observing")
                    case .failure(_):
                        self.isAnimating = false
                    }
                },
                receiveValue: { response in
                    self.isAnimating = false
                    self.sections = response.data?.sections ?? []
                    self.sections.sort { $0.order < $1.order }
                    self.badgeCount = String(response.data?.general.cartCount ?? 0)
                }
            )
            .store(in: &cancellables)
    }
    
    func addItemToWishlist(productID: Int) {
                
        wishListService.addToWishlist(request: WishlistAPIRequest(deviceToken: token, productID: productID))
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { (completion) in
                    switch completion {
                    case .finished:
                        print("Publisher stopped observing")
                    case .failure(_):
                        self.isAnimating = false
                    }
                },
                receiveValue: { response in
                    self.isAnimating = false
                }
            )
            .store(in: &cancellables)
    }
    
    func removeItemFromWishlist(productID: Int) {
                
        wishListService.removeFromWishlist(request: WishlistAPIRequest(deviceToken: token, productID: productID))
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { (completion) in
                    switch completion {
                    case .finished:
                        print("Publisher stopped observing")
                    case .failure(_):
                        self.isAnimating = false
                    }
                },
                receiveValue: { response in
                    self.isAnimating = false
                }
            )
            .store(in: &cancellables)
    }
        
}

enum ViewMoreType: Identifiable {
    case category, occation, product, brand
    var id: Int {
        self.hashValue
    }
}

extension Notification.Name {
    static let favoriteStatusChanged = Notification.Name("FavoriteStatusChanged")
}
