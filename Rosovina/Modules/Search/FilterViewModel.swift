//
//  FilterViewModel.swift
//  Rosovina
//
//  Created by Amir Ahmed on 20/01/2024.
//

import Foundation
import Combine
import Firebase

class FilterViewModel: ObservableObject {
    
    private var cancellables: Set<AnyCancellable> = []
    
    //---------------------
                
    @Published var categories: [Category] = []
    
    @Published var selectedCategories: [Int] = []
    
    @Published var brands: [String] = ["Rose Garden", "Tulip Paradise", "Daisy Delight", "Lily Blossoms", "Sunflower Haven", "Orchid Oasis", "Carnation Elegance", "Peony Palace"]
    
    @Published var filteredBrands: [String] = ["Rose Garden", "Tulip Paradise", "Daisy Delight", "Lily Blossoms", "Sunflower Haven", "Orchid Oasis", "Carnation Elegance", "Peony Palace"]
    
    @Published var minimumPriceRange: Int = 0
    
    @Published var maximumPriceRange: Int = 0
    
    @Published var currentRate: Int = 0
                            
    @Published var isAnimating = false
        
    let token = UIDevice.current.identifierForVendor!.uuidString
        
    //---------------------
        
    let dataService: HomeService
    
    init(dataService: HomeService = AppHomeService()) {
        self.dataService = dataService
        self.getCategories()
    }
        
    func getCategories() {
        
        self.isAnimating = true
        
        dataService.getCategories(isOccations: false)
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
                    self.categories = response.data?.data ?? []
                }
            )
            .store(in: &cancellables)
    }
            
}




