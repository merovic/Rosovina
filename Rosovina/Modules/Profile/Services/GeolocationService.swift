//
//  GeolocationService.swift
//  Rosovina
//
//  Created by Amir Ahmed on 05/01/2024.
//

import Foundation
import Combine
import Alamofire

protocol GeolocationService {
    func getCountries() -> AnyPublisher<BaseResponseAnother<GeoLocationAPIResponse>, AFError>
    func getCities(countryID: String) -> AnyPublisher<BaseResponseAnother<GeoLocationAPIResponse>, AFError>
    func getAreas(cityID: String) -> AnyPublisher<BaseResponseAnother<GeoLocationAPIResponse>, AFError>
}

class AppGeolocationService: GeolocationService {
    func getCountries() -> AnyPublisher<BaseResponseAnother<GeoLocationAPIResponse>, AFError> {
        return APIClient.performDecodableRequest(route: APIRouter.getCountries)
    }
    
    func getCities(countryID: String) -> AnyPublisher<BaseResponseAnother<GeoLocationAPIResponse>, AFError> {
        return APIClient.performDecodableRequest(route: APIRouter.getCities(countryID: countryID))
    }
    
    func getAreas(cityID: String) -> AnyPublisher<BaseResponseAnother<GeoLocationAPIResponse>, AFError> {
        return APIClient.performDecodableRequest(route: APIRouter.getAreas(cityID: cityID))
    }

}


