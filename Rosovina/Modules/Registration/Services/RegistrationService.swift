//
//  RegistrationService.swift
//  Teseppas Loylaty
//
//  Created by Amir Ahmed on 13/07/2022.
//

import Foundation
import Combine
import Alamofire

protocol RegistrationService {
    func check_phone(request: PhoneAPIRequest) -> AnyPublisher<CheckPhoneAPIResponse, AFError>
    func register(request: RegistrationAPIRequest) -> AnyPublisher<BaseResponseAnother<LoginAPIResponse>, AFError>
    func otp_check(request: OTPCheckAPIRequest) -> AnyPublisher<BaseResponseAnother<[String]>, AFError>
    func otp_send(request: OTPSendAPIRequest) -> AnyPublisher<BaseResponseAnother<String>, AFError>
}

class AppRegistrationService: RegistrationService {
    func check_phone(request: PhoneAPIRequest) -> AnyPublisher<CheckPhoneAPIResponse, AFError> {
        return APIClient.performDecodableRequest(route: APIRouter.check_phone(request: request))
    }
    
    func register(request: RegistrationAPIRequest) -> AnyPublisher<BaseResponseAnother<LoginAPIResponse>, AFError> {
        return APIClient.performDecodableRequest(route: APIRouter.register(request: request))
    }
    
    func otp_check(request: OTPCheckAPIRequest) -> AnyPublisher<BaseResponseAnother<[String]>, AFError> {
        return APIClient.performDecodableRequest(route: APIRouter.otp_check(request: request))
    }
    
    func otp_send(request: OTPSendAPIRequest) -> AnyPublisher<BaseResponseAnother<String>, AFError> {
        return APIClient.performDecodableRequest(route: APIRouter.otp_send(request: request))
    }
}

