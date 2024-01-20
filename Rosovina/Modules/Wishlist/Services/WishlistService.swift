//
//  WishlistService.swift
//  Rosovina
//
//  Created by Amir Ahmed on 03/01/2024.
//

import Foundation
import Combine
import Alamofire

protocol WishlistService {
    func getWishlist(deviceToken: String) -> AnyPublisher<BaseResponseAnother<WishlistAPIResponse>, AFError>
    func addToWishlist(request: WishlistAPIRequest) -> AnyPublisher<BaseResponseAnother<WishlistAPIResponse>, AFError>
    func removeFromWishlist(request: WishlistAPIRequest) -> AnyPublisher<BaseResponseAnother<WishlistAPIResponse>, AFError>
}

class AppWishlistService: WishlistService {
    func getWishlist(deviceToken: String) -> AnyPublisher<BaseResponseAnother<WishlistAPIResponse>, AFError> {
        return APIClient.performDecodableRequest(route: APIRouter.getWishlist(deviceToken: deviceToken))
    }
    
    func addToWishlist(request: WishlistAPIRequest) -> AnyPublisher<BaseResponseAnother<WishlistAPIResponse>, AFError> {
        return APIClient.performDecodableRequest(route: APIRouter.addToWishList(request: request))
    }
    
    func removeFromWishlist(request: WishlistAPIRequest) -> AnyPublisher<BaseResponseAnother<WishlistAPIResponse>, AFError> {
        return APIClient.performDecodableRequest(route: APIRouter.removeFromWishList(request: request))
    }

}



