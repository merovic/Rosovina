//
//  MyOrdersService.swift
//  Rosovina
//
//  Created by Amir Ahmed on 06/01/2024.
//

import Foundation
import Combine
import Alamofire

protocol MyOrdersService {
    func myOrders() -> AnyPublisher<BaseResponseAnother<MyOrdersAPIResponse>, AFError>
    func myOrderDetails(orderID: String) -> AnyPublisher<BaseResponseAnother<MyOrder>, AFError>
    func addReview(request: AddReviewAPIRequest) -> AnyPublisher<BaseResponseAnother<[String]>, AFError>
}

class AppMyOrdersService: MyOrdersService {
    func addReview(request: AddReviewAPIRequest) -> AnyPublisher<BaseResponseAnother<[String]>, Alamofire.AFError> {
        return APIClient.performDecodableRequest(route: APIRouter.addReview(request: request))
    }
    
    func myOrderDetails(orderID: String) -> AnyPublisher<BaseResponseAnother<MyOrder>, Alamofire.AFError> {
        return APIClient.performDecodableRequest(route: APIRouter.myOrderDetails(orderID: orderID))
    }
    
    func myOrders() -> AnyPublisher<BaseResponseAnother<MyOrdersAPIResponse>, AFError> {
        return APIClient.performDecodableRequest(route: APIRouter.myOrders)
    }
}

