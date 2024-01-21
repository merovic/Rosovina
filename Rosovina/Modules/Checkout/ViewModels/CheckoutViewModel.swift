//
//  CheckoutViewModel.swift
//  Rosovina
//
//  Created by Amir Ahmed on 05/01/2024.
//

import Foundation
import Combine
import Firebase

class CheckoutViewModel: ObservableObject {
    
    private var cancellables: Set<AnyCancellable> = []
    
    //---------------------
    
    @Published var cartResponse: GetCartAPIResponse
    
    @Published var selectedLocation: UserAddress?
    
    @Published var orderCreatedID = 0
                                        
    @Published var isAnimating = false
    
    let token = UIDevice.current.identifierForVendor!.uuidString
                
    //---------------------
        
    let dataService: CheckoutService
    let cartService: CartService
    
    init(dataService: CheckoutService = AppCheckoutService(), cartService: CartService = AppCartService(), cartResponse: GetCartAPIResponse) {
        self.dataService = dataService
        self.cartService = cartService
        self.cartResponse = cartResponse
    }
        
    func createOrder() {
        
        self.isAnimating = true

        dataService.createOrder(request: CreateOrderAPIRequest(mobileToken: token))
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
                    self.orderCreatedID = response.data ?? 0
                }
            )
            .store(in: &cancellables)
    }
    
    func updateCart() {
        
        self.isAnimating = true
        
        cartService.updateCart(request: UpdateCartAPIRequest(addressID: self.selectedLocation?.id))
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
                    self.cartResponse = response.data!
                }
            )
            .store(in: &cancellables)
    }
            
}
