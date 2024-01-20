//
//  CartService.swift
//  Rosovina
//
//  Created by Amir Ahmed on 01/01/2024.
//

import Foundation
import Combine
import Alamofire

protocol CartService {
    func getCart(deviceToken: String) -> AnyPublisher<BaseResponseAnother<GetCartAPIResponse>, AFError>
    func updateCart(request: UpdateCartAPIRequest) -> AnyPublisher<BaseResponseAnother<GetCartAPIResponse>, AFError>
    func getGiftCards() -> AnyPublisher<BaseResponseAnother<GetGiftCardsAPIResponse>, AFError>
    func checkPromoCode(request: CheckPromoCodeAPIRequest) -> AnyPublisher<BaseResponseAnother<CheckPromoCodeAPIResponse>, AFError>
}

class AppCartService: CartService {
    func checkPromoCode(request: CheckPromoCodeAPIRequest) -> AnyPublisher<BaseResponseAnother<CheckPromoCodeAPIResponse>, Alamofire.AFError> {
        return APIClient.performDecodableRequest(route: APIRouter.checkPromoCode(request: request))
    }
    
    func getGiftCards() -> AnyPublisher<BaseResponseAnother<GetGiftCardsAPIResponse>, Alamofire.AFError> {
        return APIClient.performDecodableRequest(route: APIRouter.getGiftCards)
    }
    
    func getCart(deviceToken: String) -> AnyPublisher<BaseResponseAnother<GetCartAPIResponse>, AFError> {
        return APIClient.performDecodableRequest(route: APIRouter.getCart(deviceToken: deviceToken))
    }
    
    func updateCart(request: UpdateCartAPIRequest) -> AnyPublisher<BaseResponseAnother<GetCartAPIResponse>, AFError> {
        return APIClient.performDecodableRequest(route: APIRouter.updateCart(request: request))
    }
}


