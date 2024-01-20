//
//  ResetPasswordService.swift
//  Teseppas Loylaty
//
//  Created by Amir Ahmed on 20/08/2022.
//

import Foundation
import Combine
import Alamofire

protocol ResetPasswordService {
    func check_phone(request: PhoneAPIRequest) -> AnyPublisher<CheckPhoneAPIResponse, AFError>
    func otp_check(request: OTPCheckAPIRequest) -> AnyPublisher<BaseResponseAnother<[String]>, AFError>
    func otp_send(request: OTPSendAPIRequest) -> AnyPublisher<BaseResponseAnother<String>, AFError>
    func resetPassword(request: ResetPasswordAPIRequest, token: String) -> AnyPublisher<BaseResponseAnother<[String]>, AFError>
    func generateToken(phone: String) -> AnyPublisher<BaseResponseAnother<GenerateTokenAPIResponse>, AFError>
}

class AppResetPasswordService: ResetPasswordService {
    func resetPassword(request: ResetPasswordAPIRequest, token: String) -> AnyPublisher<BaseResponseAnother<[String]>, AFError> {
        return APIClient.performDecodableRequest(route: APIRouter.reset_password(request: request, token: token))
    }
    
    func generateToken(phone: String) -> AnyPublisher<BaseResponseAnother<GenerateTokenAPIResponse>, AFError> {
        return APIClient.performDecodableRequest(route: APIRouter.generate_token(request: PhoneAPIRequest(phone: phone)))
    }
    
    func check_phone(request: PhoneAPIRequest) -> AnyPublisher<CheckPhoneAPIResponse, AFError> {
        return APIClient.performDecodableRequest(route: APIRouter.check_phone(request: request))
    }
    
    func otp_check(request: OTPCheckAPIRequest) -> AnyPublisher<BaseResponseAnother<[String]>, AFError> {
        return APIClient.performDecodableRequest(route: APIRouter.otp_check(request: request))
    }
    
    func otp_send(request: OTPSendAPIRequest) -> AnyPublisher<BaseResponseAnother<String>, AFError> {
        return APIClient.performDecodableRequest(route: APIRouter.otp_send(request: request))
    }
    
}

