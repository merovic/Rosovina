//
//  InitCountryViewModel.swift
//  Rosovina
//
//  Created by Amir Ahmed on 18/02/2024.
//

import Foundation
import Combine

class InitCountryViewModel: ObservableObject {
    
    private var cancellables: Set<AnyCancellable> = []
    
    //---------------------
    
    @Published var countries: [GeoLocationAPIResponseElement] = []
    @Published var cities: [GeoLocationAPIResponseElement] = []
    
    @Published var selectedCountry: GeoLocationAPIResponseElement?
    @Published var selectedCity: GeoLocationAPIResponseElement?
    
    @Published var continueClicked = false
    
    @Published var isAnimating = false
        
    //---------------------
        
    let dataService: GeolocationService
    
    init(dataService: GeolocationService = AppGeolocationService()) {
        self.dataService = dataService
        getCountries()
    }
  
    func getCountries() {
                
        dataService.getCountries()
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
                    self.countries = response.data ?? []
                    self.selectedCountry = response.data![0]
                    self.getCities(countryID: String(response.data![0].id))
                }
            )
            .store(in: &cancellables)
    }
    
    func getCities(countryID: String) {
                
        dataService.getCities(countryID: countryID)
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
                    self.cities = response.data ?? []
                    self.selectedCity = response.data![0]
                }
            )
            .store(in: &cancellables)
    }
}
