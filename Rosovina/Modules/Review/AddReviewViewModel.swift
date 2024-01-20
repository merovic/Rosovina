//
//  AddReviewViewModel.swift
//  Rosovina
//
//  Created by Amir Ahmed on 20/01/2024.
//

import Foundation
import Combine
import Firebase

class AddReviewViewModel: ObservableObject {
    
    private var cancellables: Set<AnyCancellable> = []
    
    //---------------------
    
    @Published var productName: String = ""
    
    @Published var productImage: String = ""
        
    @Published var rateValue: Int = 0
    
    @Published var commentValue: String = ""
    
    @Published var productReviewed: Bool = false
                                                
    @Published var isAnimating = false
                
    //---------------------
        
    let dataService: MyOrdersService
    var item: MyOrderItem
    
    init(dataService: MyOrdersService = AppMyOrdersService(), item: MyOrderItem) {
        self.dataService = dataService
        self.item = item
        
        self.productName = item.productName
        self.productImage = item.imageURL
    }
        
    func AddReview() {
        
        self.isAnimating = true
        
        dataService.addReview(request: AddReviewAPIRequest(productID: item.productID, rate: rateValue, comment: commentValue))
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
                    self.productReviewed = response.success
                }
            )
            .store(in: &cancellables)
    }
            
}



