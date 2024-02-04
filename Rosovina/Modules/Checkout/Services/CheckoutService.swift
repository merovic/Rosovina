//
//  CheckoutService.swift
//  Rosovina
//
//  Created by Amir Ahmed on 05/01/2024.
//

import Foundation
import Combine
import Alamofire

protocol CheckoutService {
    func createOrder(request: CreateOrderAPIRequest) -> AnyPublisher<BaseResponseAnother<Int>, AFError>
    func checkPromoCode(request: CheckPromoCodeAPIRequest) -> AnyPublisher<BaseResponseAnother<CheckPromoCodeAPIResponse>, AFError>
    func confirmOrder(request: ConfirmOrderAPIRequest) -> AnyPublisher<BaseResponseAnother<ConfirmOrderAPIResponse>, AFError>
}

class AppCheckoutService: CheckoutService {
    func confirmOrder(request: ConfirmOrderAPIRequest) -> AnyPublisher<BaseResponseAnother<ConfirmOrderAPIResponse>, AFError> {
        return APIClient.performDecodableRequest(route: APIRouter.confirmOrder(request: request))
    }
    
    func checkPromoCode(request: CheckPromoCodeAPIRequest) -> AnyPublisher<BaseResponseAnother<CheckPromoCodeAPIResponse>, Alamofire.AFError> {
        return APIClient.performDecodableRequest(route: APIRouter.checkPromoCode(request: request))
    }
    
    func createOrder(request: CreateOrderAPIRequest) -> AnyPublisher<BaseResponseAnother<Int>, AFError> {
        return APIClient.performDecodableRequest(route: APIRouter.createOrder(request: request))
    }
}
