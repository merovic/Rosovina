//
//  LoginService.swift
//  Abshare
//
//  Created by Apple on 06/10/2021.
//

import Foundation
import Combine
import Alamofire

protocol LoginService {
    func login(request: LoginAPIRequest) -> AnyPublisher<BaseResponseAnother<LoginAPIResponse>, AFError>
}

class AppLoginService: LoginService {
    func login(request: LoginAPIRequest) -> AnyPublisher<BaseResponseAnother<LoginAPIResponse>, AFError> {
        return APIClient.performDecodableRequest(route: APIRouter.login(request: request))
    }
}
