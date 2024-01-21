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
    
    @Published var selectedCategory: DynamicHomeModel?
                        
    @Published var isAnimating = false
    
    let token = UIDevice.current.identifierForVendor!.uuidString
        
    //---------------------
        
    let dataService: HomeService
    let wishListService: WishlistService
    
    init(dataService: HomeService = AppHomeService(), wishListService: WishlistService = AppWishlistService()) {
        self.dataService = dataService
        self.wishListService = wishListService
    }
    
    func home() {
        
        self.isAnimating = true

        dataService.home()
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