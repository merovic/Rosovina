//
//  MyOrdersViewModel.swift
//  Rosovina
//
//  Created by Amir Ahmed on 06/01/2024.
//

import Foundation
import Combine
import Firebase

class MyOrdersViewModel: ObservableObject {
    
    private var cancellables: Set<AnyCancellable> = []
    
    //---------------------
    
    @Published var myCurrentOrders: [MyOrder] = []
    @Published var myHistoryOrders: [MyOrder] = []
    
    @Published var selectedOrderID: Int?
                                            
    @Published var isAnimating = false
                
    //---------------------
        
    let dataService: MyOrdersService
    
    init(dataService: MyOrdersService = AppMyOrdersService()) {
        self.dataService = dataService
        self.getMyOrders()
    }
        
    func getMyOrders() {
        
        self.isAnimating = true
        
        dataService.myOrders()
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
                    self.myCurrentOrders = response.data!.filter{ ($0.statusID != 6) }
                    self.myHistoryOrders = response.data!.filter{ ($0.statusID == 6) }
                }
            )
            .store(in: &cancellables)
    }
            
}


