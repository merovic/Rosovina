//
//  OrderCustomizeViewModel.swift
//  Rosovina
//
//  Created by Amir Ahmed on 18/01/2024.
//

import Foundation
import Combine
import Firebase

class OrderCustomizeViewModel: ObservableObject {
    
    private var cancellables: Set<AnyCancellable> = []
    
    //---------------------
    
    @Published var giftCards: [GiftCard] = []
    
    @Published var toText: String = ""
    
    @Published var messageText: String = ""
    
    @Published var shareLink: String = ""
    
    @Published var selectedGiftCardID: Int = 0
    
    @Published var cartUpdated = false
    
    @Published var errorMessage = ""
    
    @Published var isAnimating = false
                
    //---------------------
        
    let dataService: CartService
    var cartResponse: GetCartAPIResponse
    
    init(dataService: CartService = AppCartService(), cartResponse: GetCartAPIResponse) {
        self.dataService = dataService
        self.cartResponse = cartResponse
        getGiftCards()
    }
        
    func getGiftCards() {
        
        self.isAnimating = true

        dataService.getGiftCards()
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
                    self.giftCards = response.data ?? []
                }
            )
            .store(in: &cancellables)
    }
    
    func updateCartForCustomize() {
        
        if selectedGiftCardID != 0 && !toText.isEmpty && !messageText.isEmpty {
            dataService.updateCart(request: UpdateCartAPIRequest(customize: Customize(cardID: selectedGiftCardID, to: toText, message: messageText, feelingLink: shareLink)))
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
                        self.cartUpdated = response.success
                    }
                )
                .store(in: &cancellables)
        } else{
            errorMessage = "check_your_inputs_first".localized
        }
        
    }
            
}

