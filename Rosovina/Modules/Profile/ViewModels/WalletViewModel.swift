//
//  WalletViewModel.swift
//  Rosovina
//
//  Created by PaySky106 on 20/02/2024.
//

import Foundation
import Combine

class WalletViewModel: ObservableObject {
    
    private var cancellables: Set<AnyCancellable> = []
    
    //---------------------
                                            
    @Published var isAnimating = false
                
    //---------------------
        
    let dataService: AddressService
    
    init(dataService: AddressService = AppAddressService()) {
        self.dataService = dataService
    }
            
}
