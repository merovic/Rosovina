//
//  ViewMoreViewModel.swift
//  Rosovina
//
//  Created by Amir Ahmed on 08/02/2024.
//

import Foundation
import Combine

class ViewMoreViewModel: ObservableObject {
    
    private var cancellables: Set<AnyCancellable> = []
    
    //---------------------
    
    @Published var selectedProductID: Int = 0
    
    @Published var categoryName: String = ""
    
    @Published var selectedCategory: DynamicHomeModel?
     
    @Published var viewMoreItems: [DynamicHomeModel] = []
                        
    @Published var isAnimating = false
                
    //---------------------
            
    var viewMoreType: ViewMoreType
    
    init(viewMoreItems: [DynamicHomeModel], viewMoreType: ViewMoreType) {
        self.viewMoreItems = viewMoreItems
        self.viewMoreType = viewMoreType
        
        switch viewMoreType {
        case .category:
            self.categoryName = "Categories"
        case .occation:
            self.categoryName = "Occations"
        case .product:
            self.categoryName = "Products"
        case .brand:
            self.categoryName = "Brands"
        }
    }
            
}
