//
//  TabbyViewModel.swift
//  Rosovina
//
//  Created by Amir Ahmed on 25/03/2024.
//

import Foundation
import Combine
import Tabby

class TabbyViewModel: ObservableObject {
    
    private var cancellables: Set<AnyCancellable> = []
    
    //---------------------
    
    @Published var tabbyPayment: TabbyCheckoutPayload?
    @Published var tabbyResult: TabbyResult?
                
    //---------------------
            
    init(myTestPayment: TabbyCheckoutPayload) {
        self.tabbyPayment = myTestPayment
    }
}


