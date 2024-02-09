//
//  WishlistViewModel.swift
//  Rosovina
//
//  Created by Amir Ahmed on 03/01/2024.
//

import Foundation
import Combine
import Firebase

class WishlistViewModel: ObservableObject {
    
    private var cancellables: Set<AnyCancellable> = []
    
    //---------------------
                
    @Published var wishlistItems: [WishlistItem] = []
    
    @Published var selectedProductID: Int = 0
                        
    @Published var isAnimating = false
        
    let token = UIDevice.current.identifierForVendor!.uuidString
        
    //---------------------
        
    let dataService: WishlistService
    
    init(dataService: WishlistService = AppWishlistService()) {
        self.dataService = dataService
    }
        
    func getWishlist() {
        
        self.isAnimating = true
        
        dataService.getWishlist(deviceToken: token)
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
                    self.wishlistItems = response.data?.items ?? []
                }
            )
            .store(in: &cancellables)
    }
    
    func addItemToWishlist(productID: Int) {
                
        dataService.addToWishlist(request: WishlistAPIRequest(deviceToken: token, productID: productID))
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
                    self.wishlistItems = response.data?.items ?? []
                }
            )
            .store(in: &cancellables)
    }
    
    func removeItemFromWishlist(productID: Int) {
        
        self.isAnimating = true
        
        dataService.removeFromWishlist(request: WishlistAPIRequest(deviceToken: token, productID: productID))
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
                    self.wishlistItems = response.data?.items ?? []
                }
            )
            .store(in: &cancellables)
    }
            
}
