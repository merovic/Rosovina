//
//  ProductDetailsViewModel.swift
//  Rosovina
//
//  Created by Amir Ahmed on 31/12/2023.
//

import Foundation
import Combine
import Firebase

class ProductDetailsViewModel: ObservableObject {
    
    private var cancellables: Set<AnyCancellable> = []
    
    //---------------------
    
    @Published var productDetails: ProductDetailsAPIResponse?
    
    @Published var productQuantity = 1
    
    @Published var productQuantityText = "1"
    
    @Published var cartResponse: GetCartAPIResponse?
    
    @Published var itemAdded = false
                    
    @Published var isAnimating = false
    
    let token = UIDevice.current.identifierForVendor!.uuidString
    
    var productID: Int
            
    //---------------------
        
    let dataService: ProductDetailsService
    let cartDataService: CartService
    let wishListService: WishlistService
    
    init(productID: Int ,dataService: ProductDetailsService = AppProductDetailsService(), cartDataService: CartService = AppCartService(), wishListService: WishlistService = AppWishlistService()) {
        self.dataService = dataService
        self.cartDataService = cartDataService
        self.wishListService = wishListService
        self.productID = productID
        self.getProductDetails()
    }
    
    func getProductDetails() {
        
        self.isAnimating = true

        dataService.getProductDetails(productID: String(self.productID))
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
                    self.productDetails = response.data
                    self.getCart()
                }
            )
            .store(in: &cancellables)
    }
    
    func getCart() {
        
        cartDataService.getCart(deviceToken: token)
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
                    self.cartResponse = response.data
                }
            )
            .store(in: &cancellables)
    }
    
    func updateCart() {
        
        self.isAnimating = true

        var apiArray: [APICartItem] = []
        
        if let items = self.cartResponse{
            for cartItem in items.items{
                apiArray.append(APICartItem(productID: cartItem.productID, quantity: Int(Double(cartItem.quantity) ?? 0.0), attributeValueIDS: [2]))
            }
        }
        
        apiArray.append(APICartItem(productID: self.productDetails!.id, quantity: productQuantity, attributeValueIDS: [2]))
        
        cartDataService.updateCart(request: UpdateCartAPIRequest(items: apiArray))
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
                    self.cartResponse = response.data
                    self.itemAdded = true
                }
            )
            .store(in: &cancellables)
    }
    
    func addItemToWishlist() {
                
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
    
    func removeItemFromWishlist() {
                
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
    
    func increaseQuantity(){
        self.productQuantity += 1
        self.productQuantityText = String(productQuantity)
    }
    
    func decressQuantity(){
        if self.productQuantity != 1{
            self.productQuantity -= 1
            self.productQuantityText = String(productQuantity)
        }
    }
        
}

