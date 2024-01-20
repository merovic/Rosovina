//
//  AddAddressViewModel.swift
//  Rosovina
//
//  Created by Amir Ahmed on 04/01/2024.
//

import Foundation
import Combine
import Firebase

class AddAddressViewModel: ObservableObject {
    
    private var cancellables: Set<AnyCancellable> = []
    
    //---------------------
    
    @Published var addressName = ""
    @Published var addressContent = ""
    @Published var addressCoordinates = "20.434634634634, 21.3463463463"
    @Published var buildingNo = ""
    @Published var floorNo = ""
    @Published var flatNo = ""
    @Published var postalCode = ""
    @Published var isDefault = false
    @Published var countries: [GeoLocationAPIResponseElement] = []
    @Published var cities: [GeoLocationAPIResponseElement] = []
    @Published var areas: [GeoLocationAPIResponseElement] = []
    
    @Published var selectedCountry: GeoLocationAPIResponseElement?
    @Published var selectedCity: GeoLocationAPIResponseElement?
    @Published var selectedArea: GeoLocationAPIResponseElement?
    
    @Published var addedAddress: UserAddress?
                                            
    @Published var isAnimating = false
        
    let token = UIDevice.current.identifierForVendor!.uuidString
        
    //---------------------
        
    let dataService: AddressService
    let geolocationService: GeolocationService
    var addressToUpdate: UserAddress?
    var mapLocation: GooglePlaceLocation?
    
    init(dataService: AddressService = AppAddressService(), geolocationService: GeolocationService = AppGeolocationService(), addressToUpdate: UserAddress? = nil, mapLocation: GooglePlaceLocation? = nil) {
        self.dataService = dataService
        self.geolocationService = geolocationService
        self.addressToUpdate = addressToUpdate
        self.mapLocation = mapLocation
        self.getCountries()
        
        if let address = addressToUpdate{
            self.addressName = address.name
            self.addressContent = address.address
            self.addressCoordinates = address.coordinates
            self.selectedCountry = GeoLocationAPIResponseElement(id: address.countryID, name: address.countryName)
            self.selectedCity = GeoLocationAPIResponseElement(id: address.cityID, name: address.cityName)
            self.selectedArea = GeoLocationAPIResponseElement(id: address.areaID, name: address.areaName)
            self.buildingNo = address.buildingNo
            self.floorNo = address.floorNo ?? ""
            self.flatNo = address.flatNo ?? ""
            self.postalCode = address.postalCode ?? ""
        }
        
        if let location = mapLocation{
            self.addressCoordinates = String(location.locationCoordinates?.latitude ?? 0.0) + ", " + String(location.locationCoordinates?.longitude ?? 0.0)
            self.addressName = location.locationName ?? ""
            self.addressContent = location.locationAddress ?? ""
        }
    }
        
    func addAddress() {
        
        self.isAnimating = true
        
        dataService.addAddress(request: AddUserAddress(name: addressName, address: addressContent, coordinates: addressCoordinates, countryID: selectedCountry!.id, cityID: selectedCity!.id, areaID: selectedArea!.id, buildingNo: buildingNo, floorNo: floorNo, flatNo: flatNo, postalCode: postalCode, notes: "", isDefault: isDefault))
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
                    self.addedAddress = response.data
                }
            )
            .store(in: &cancellables)
    }
    
    func updateAddress() {
        
        self.isAnimating = true
        
        dataService.updateAddress(addressID: String(addressToUpdate!.id ?? 0), request: AddUserAddress(name: addressName, address: addressContent, coordinates: addressCoordinates, countryID: selectedCountry!.id, cityID: selectedCity!.id, areaID: selectedArea!.id, buildingNo: buildingNo, floorNo: floorNo, flatNo: flatNo, postalCode: postalCode, notes: "", isDefault: isDefault))
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
                }
            )
            .store(in: &cancellables)
    }
    
    func getCountries() {
                
        geolocationService.getCountries()
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
                
        geolocationService.getCities(countryID: countryID)
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
                    self.getAreas(cityID: String(response.data![0].id))
                }
            )
            .store(in: &cancellables)
    }
    
    func getAreas(cityID: String) {
                
        geolocationService.getAreas(cityID: cityID)
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
                    self.areas = response.data ?? []
                    self.selectedArea = response.data![0]
                }
            )
            .store(in: &cancellables)
    }
            
}

enum DropDownSelection: Identifiable {
    case countries, cities, areas
    var id: Int {
        self.hashValue
    }
}
