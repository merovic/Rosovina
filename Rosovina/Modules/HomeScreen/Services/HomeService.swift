//
//  HomeService.swift
//  Rosovina
//
//  Created by Amir Ahmed on 29/12/2023.
//

import Foundation
import Combine
import Alamofire

protocol HomeService {
    func home(deviceToken: String) -> AnyPublisher<BaseResponseAnother<HomeAPIResponse>, AFError>
    func getProducts(request: GetProductsAPIRequest) -> AnyPublisher<BaseResponseAnother<GetProductsAPIResponse>, AFError>
    func getCategories(isOccations: Bool)  -> AnyPublisher<BaseResponseAnother<GetCategoriesAPIResponse>, AFError>
}

class AppHomeService: HomeService {
    func getCategories(isOccations: Bool) -> AnyPublisher<BaseResponseAnother<GetCategoriesAPIResponse>, Alamofire.AFError> {
        return APIClient.performDecodableRequest(route: APIRouter.getCategories(isOccasion: isOccations))
    }
    
    func getProducts(request: GetProductsAPIRequest) -> AnyPublisher<BaseResponseAnother<GetProductsAPIResponse>, AFError> {
        return APIClient.performDecodableRequest(route: APIRouter.getProducts(request: request))
    }
    
    func home(deviceToken: String) -> AnyPublisher<BaseResponseAnother<HomeAPIResponse>, AFError> {
        return APIClient.performDecodableRequest(route: APIRouter.home(deviceToken: deviceToken))
    }
}

