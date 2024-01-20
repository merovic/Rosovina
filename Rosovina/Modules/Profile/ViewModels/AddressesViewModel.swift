//
//  AddressesViewModel.swift
//  Rosovina
//
//  Created by Amir Ahmed on 04/01/2024.
//

import Foundation
import Combine
import Firebase

class AddressesViewModel: ObservableObject {
    
    private var cancellables: Set<AnyCancellable> = []
    
    //---------------------
                
    @Published var userAddresses: [UserAddress] = []
                            
    @Published var isAnimating = false
                
    //---------------------
        
    let dataService: AddressService
    
    init(dataService: AddressService = AppAddressService()) {
        self.dataService = dataService
        getAddresses()
    }
        
    func getAddresses() {
        
        self.isAnimating = true
        
        dataService.getUserAddress()
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
                    self.userAddresses = response.data ?? []
                }
            )
            .store(in: &cancellables)
    }
    
    func deleteAddress(addressID: String) {
        
        self.isAnimating = true
        
        dataService.removeAddress(addressID: addressID)
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
