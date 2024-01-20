//
//  APIClient.swift
//  CombineNetworking
//
//  Created by Amir Ahmed on 11/12/2023.
//

import Foundation
import Combine
import Alamofire

class APIClient {
    private static var cancellables: Set<AnyCancellable> = []
    
    @discardableResult
    static func performDecodableRequest<T: Decodable>(route: APIRouter, decoder: JSONDecoder = JSONDecoder()) -> AnyPublisher<T, AFError> where T : Decodable {
        return Future<T, AFError> { promise in
            AF.request(route)
                .publishDecodable(type: T.self, decoder: decoder, emptyResponseCodes: [200, 204, 205])
                .sink { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        promise(.failure(error.asAFError(orFailWith: "Error")))
                    }
                } receiveValue: { response in
                    CustomPrint.swiftyAPIPrint(request: response.request!, response: response.result, isDecodable: true)
                    if let value = response.value {
                        CustomPrint.swiftyAPIPrintString(data: response.data)
                        promise(.success(value))
                    }
                    else if let error = response.error {
                        promise(.failure(error))
                        CustomPrint.swiftyAPIPrintString(data: response.data)
                        CustomPrint.swiftyAPIPrintError(message: error.localizedDescription)
                    } else {
                        let unknownError = AFError.responseSerializationFailed(reason: .inputDataNilOrZeroLength)
                        promise(.failure(unknownError))
                    }
                }
                .store(in: &cancellables)
        }
        .eraseToAnyPublisher()
    }
    
    @discardableResult
    static func performStringRequest(route: APIRouter) -> AnyPublisher<String, AFError> {
        return Future<String, AFError> { promise in
            AF.request(route)
                .validate(statusCode: 200..<300)
                .publishString(encoding: .utf8)
                .sink { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        promise(.failure(error.asAFError(orFailWith: "Error")))
                    }
                } receiveValue: { response in
                    CustomPrint.swiftyAPIPrint(request: response.request!, response: response.result, isDecodable: false)
                    if let responseString = response.value {
                        promise(.success(responseString))
                    } else {
                        let unknownError = AFError.responseSerializationFailed(reason: .inputDataNilOrZeroLength)
                        promise(.failure(unknownError))
                    }
                }
                .store(in: &cancellables)
            
        }
        .eraseToAnyPublisher()
        
    }
    
    @discardableResult
    static func performMultiPartRequest<T: Decodable>(route: APIRouter, data: @escaping (MultipartFormData) -> Void, decoder: JSONDecoder = JSONDecoder()) -> AnyPublisher<T, AFError> {
        return Future { promise in
            AF.upload(multipartFormData: data, with: route)
                .publishDecodable(type: T.self, decoder: decoder, emptyResponseCodes: [200, 204, 205])
                .sink { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        promise(.failure(error.asAFError(orFailWith: "Error")))
                    }
                } receiveValue: { response in
                    CustomPrint.swiftyAPIPrint(request: response.request!, response: response.result, isDecodable: true)
                    if let value = response.value {
                        CustomPrint.swiftyAPIPrintString(data: response.data)
                        promise(.success(value))
                    }
                    else if let error = response.error {
                        promise(.failure(error))
                        CustomPrint.swiftyAPIPrintString(data: response.data)
                        CustomPrint.swiftyAPIPrintError(message: error.localizedDescription)
                    } else {
                        let unknownError = AFError.responseSerializationFailed(reason: .inputDataNilOrZeroLength)
                        promise(.failure(unknownError))
                    }
                }
                .store(in: &cancellables)
        }
        .eraseToAnyPublisher()
    }
}

