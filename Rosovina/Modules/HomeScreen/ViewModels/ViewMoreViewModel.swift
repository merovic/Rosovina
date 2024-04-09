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
            self.categoryName = "categories".localized
        case .occation:
            self.categoryName = "occasions".localized
        case .product:
            self.categoryName = "_5_products".localized
        case .brand:
            self.categoryName = "explore_brands".localized
        }
    }
            
}
