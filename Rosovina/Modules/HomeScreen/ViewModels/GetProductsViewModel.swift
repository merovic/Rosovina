//
//  GetProductsViewModel.swift
//  Rosovina
//
//  Created by Amir Ahmed on 03/01/2024.
//

import Foundation
import Combine
import Firebase

class GetProductsViewModel: ObservableObject {
    
    private var cancellables: Set<AnyCancellable> = []
    
    //---------------------
                
    @Published var productItems: [Product] = []
    
    @Published var selectedProductID: Int = 0
    
    @Published var categoryName: String = ""
                        
    @Published var isAnimating = false
        
    let token = UIDevice.current.identifierForVendor!.uuidString
        
    //---------------------
        
    let dataService: HomeService
    let wishListService: WishlistService
    
    var productType: ProductType
    var typeName: String
    var typeID: Int
    
    init(dataService: HomeService = AppHomeService(), wishListService: WishlistService = AppWishlistService(), productType: ProductType, typeName: String, typeID: Int) {
        self.dataService = dataService
        self.wishListService = wishListService
        self.productType = productType
        self.typeName = typeName
        self.typeID = typeID
        self.categoryName = typeName
        getProducts()
    }
        
    func getProducts() {
        
        self.isAnimating = true
        
        var request: GetProductsAPIRequest?
        
        switch productType{
        case .category:
            request = GetProductsAPIRequest(deviceToken: token, categories: [typeID])
        case .occation:
            request = GetProductsAPIRequest(deviceToken: token, filter: Filter(occassions: [typeID]))
        }
        
        dataService.getProducts(request: request!)
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

enum ProductType: Identifiable {
    case category, occation
    var id: Int {
        self.hashValue
    }
}
