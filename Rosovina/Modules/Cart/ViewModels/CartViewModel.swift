//
//  CartViewModel.swift
//  Rosovina
//
//  Created by Amir Ahmed on 01/01/2024.
//

import Foundation
import Combine
import Firebase

class CartViewModel: ObservableObject {
    
    private var cancellables: Set<AnyCancellable> = []
    
    //---------------------
                
    @Published var cartResponse: GetCartAPIResponse?
    
    @Published var promocodeText: String = ""
    
    @Published var errorMessage: String = ""
                        
    @Published var isAnimating = false
    
    let token = UIDevice.current.identifierForVendor!.uuidString
                
    //---------------------
        
    let dataService: CartService
    
    init(dataService: CartService = AppCartService()) {
        self.dataService = dataService
        self.getCart()
    }
        
    func getCart() {
        
        self.isAnimating = true
        
        dataService.getCart(deviceToken: token)
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
        
        for cartItem in self.cartResponse!.items{
            apiArray.append(APICartItem(productID: cartItem.productID, quantity: Int(Double(cartItem.quantity) ?? 0.0), attributeValueIDS: [cartItem.itemAttributeValues[0].productAttributeValueID]))
        }
        
        dataService.updateCart(request: UpdateCartAPIRequest(items: apiArray))
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
    
    func updateCartForPromoCode(promoCodeID: Int) {
                
        dataService.updateCart(request: UpdateCartAPIRequest(promoCodeID: promoCodeID))
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
    
    func checkPromoCode() {
        
        if !self.promocodeText.isEmpty {
            self.isAnimating = true
            dataService.checkPromoCode(request: CheckPromoCodeAPIRequest(code: self.promocodeText, amount: cartResponse?.total ?? 0))
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
                        if response.success{
                            self.updateCartForPromoCode(promoCodeID: response.data?.id ?? 0)
                        }else{
                            self.errorMessage = response.message
                        }
                    }
                )
                .store(in: &cancellables)
        }else{
            self.errorMessage = "promoCode_error_2".localized
        }
        
    }
        
}


