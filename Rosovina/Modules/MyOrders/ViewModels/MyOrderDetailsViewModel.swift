//
//  MyOrderDetailsViewModel.swift
//  Rosovina
//
//  Created by Amir Ahmed on 15/01/2024.
//

import Foundation
import Combine
import Firebase

class MyOrderDetailsViewModel: ObservableObject {
    
    private var cancellables: Set<AnyCancellable> = []
    
    //---------------------
    
    @Published var myOrder: MyOrder?
    
    @Published var selectedItem: MyOrderItem?
                                            
    @Published var isAnimating = false
                
    //---------------------
        
    let dataService: MyOrdersService
    var orderID: String
    
    
    init(dataService: MyOrdersService = AppMyOrdersService(), orderID: String) {
        self.dataService = dataService
        self.orderID = orderID
        getMyOrder()
    }
        
    func getMyOrder() {
        
        self.isAnimating = true
        
        dataService.myOrderDetails(orderID: orderID)
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
                    self.myOrder = response.data!
                }
            )
            .store(in: &cancellables)
    }
            
}



