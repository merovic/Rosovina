//
//  SelectAddressViewModel.swift
//  Rosovina
//
//  Created by Amir Ahmed on 06/01/2024.
//

import Foundation
import Combine
import Firebase

class SelectAddressViewModel: ObservableObject {
    
    private var cancellables: Set<AnyCancellable> = []
    
    //---------------------
    
    @Published var userAddresses: [UserAddress] = []
    
    @Published var selectedAddress: UserAddress?
                                        
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
            
}

