//
//  ProductDetailsService.swift
//  Rosovina
//
//  Created by Amir Ahmed on 31/12/2023.
//

import Foundation
import Combine
import Alamofire

protocol ProductDetailsService {
    func getProductDetails(productID: String) -> AnyPublisher<BaseResponseAnother<ProductDetailsAPIResponse>, AFError>
}

class AppProductDetailsService: ProductDetailsService {
    func getProductDetails(productID: String) -> AnyPublisher<BaseResponseAnother<ProductDetailsAPIResponse>, AFError> {
        return APIClient.performDecodableRequest(route: APIRouter.product_details(productID: productID))
    }
}
