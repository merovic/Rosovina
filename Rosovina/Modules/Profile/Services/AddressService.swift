//
//  AddressService.swift
//  Rosovina
//
//  Created by Amir Ahmed on 04/01/2024.
//

import Foundation
import Combine
import Alamofire

protocol AddressService {
    func getUserAddress() -> AnyPublisher<BaseResponseAnother<GetAddressesAPIResponse>, AFError>
    func addAddress(request: AddUserAddress) -> AnyPublisher<BaseResponseAnother<UserAddress>, AFError>
    func updateAddress(addressID: String,request: AddUserAddress) -> AnyPublisher<BaseResponseAnother<UserAddress>, AFError>
    func removeAddress(addressID: String) -> AnyPublisher<BaseResponseAnother<GetAddressesAPIResponse>, AFError>
}

class AppAddressService: AddressService {
    func getUserAddress() -> AnyPublisher<BaseResponseAnother<GetAddressesAPIResponse>, AFError> {
        return APIClient.performDecodableRequest(route: APIRouter.getUserAddresses)
    }
    
    func addAddress(request: AddUserAddress) -> AnyPublisher<BaseResponseAnother<UserAddress>, AFError> {
        return APIClient.performDecodableRequest(route: APIRouter.addAddress(request: request))
    }
    
    func updateAddress(addressID: String, request: AddUserAddress) -> AnyPublisher<BaseResponseAnother<UserAddress>, AFError> {
        return APIClient.performDecodableRequest(route: APIRouter.updateAddress(addressID: addressID, request: request))
    }
    
    func removeAddress(addressID: String) -> AnyPublisher<BaseResponseAnother<GetAddressesAPIResponse>, AFError> {
        return APIClient.performDecodableRequest(route: APIRouter.removeAddress(addressID: addressID))
    }

}

