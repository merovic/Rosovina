//
//  ProfileService.swift
//  Rosovina
//
//  Created by Amir Ahmed on 18/01/2024.
//

import Foundation
import Combine
import Alamofire

protocol ProfileService {
    func updateAccount(image: Data, name: String, email: String) -> AnyPublisher<BaseResponseAnother<UpdateAccountAPIResponse>, AFError>
    func deleteAccount() -> AnyPublisher<BaseResponseAnother<[String]>, AFError>
}

class AppProfileService: ProfileService {
    func deleteAccount() -> AnyPublisher<BaseResponseAnother<[String]>, AFError> {
        return APIClient.performDecodableRequest(route: APIRouter.deleteAccount)
    }
    
    func updateAccount(image: Data, name: String, email: String) -> AnyPublisher<BaseResponseAnother<UpdateAccountAPIResponse>, AFError> {
        return APIClient.performMultiPartRequest(route: APIRouter.updateAccount(name: name, email: email), data: { multiPart in
            let params = ["name": name, "email": email]
            for (key, value) in params {
                multiPart.append(value.data(using: .utf8)!, withName: key)
            }
            multiPart.append(image, withName: "image_url", fileName: "image.png", mimeType: "image/png")
        })
    }

}


