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
    
    @Published var userTransactions: [UserTransaction] = []
    @Published var userBalance = ""
                                            
    @Published var isAnimating = false
                
    //---------------------
        
    let dataService: ProfileService
    
    init(dataService: ProfileService = AppProfileService()) {
        self.dataService = dataService
        self.getUserWallet()
    }
    
    func getUserWallet() {
        
        self.isAnimating = true
        
        dataService.getUserWallet()
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
                    self.userBalance = String(response.data?.balance ?? 0)
                    self.getUserTransactions()
                }
            )
            .store(in: &cancellables)
    }
    
    func getUserTransactions() {
                
        dataService.getUserTransactions()
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
                    self.userTransactions = response.data ?? []
                }
            )
            .store(in: &cancellables)
    }
            
}
