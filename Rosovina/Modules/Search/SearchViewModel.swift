//
//  SearchViewModel.swift
//  Rosovina
//
//  Created by Amir Ahmed on 20/01/2024.
//

import Foundation
import Combine
import Firebase

class SearchViewModel: ObservableObject {
    
    private var cancellables: Set<AnyCancellable> = []
    
    //---------------------
                
    @Published var productItems: [Product] = []
    
    @Published var selectedProductID: Int = 0
    
    @Published var searchText: String = ""
                        
    @Published var isAnimating = false
        
    let token = UIDevice.current.identifierForVendor!.uuidString
        
    //---------------------
        
    let dataService: HomeService
    let wishListService: WishlistService
    
    init(dataService: HomeService = AppHomeService(), wishListService: WishlistService = AppWishlistService()) {
        self.dataService = dataService
        self.wishListService = wishListService
    }
    
    func getProductsByFilter(categories: [Int], priceRange: [Int], brands: [Int], rating: [Int]) {
        
        self.isAnimating = true
        
        dataService.getProducts(request: GetProductsAPIRequest(deviceToken: token, filter: Filter(occassions: categories, price: priceRange, brands: brands, rating: rating)))
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
                    self.productItems = response.data?.data ?? []
                }
            )
            .store(in: &cancellables)
    }
    
    func getProductsBySearch() {
        
        self.isAnimating = true
        
        dataService.getProducts(request: GetProductsAPIRequest(deviceToken: token, keyword: searchText))
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
                    self.productItems = response.data?.data ?? []
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
