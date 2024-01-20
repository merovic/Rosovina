//
//  CommonResponse.swift
//  Abshare
//
//  Created by Apple on 23/10/2021.
//

import Foundation

// MARK: - BaseResponse
public struct BaseResponse<T: Codable>: Codable, Equatable where T: Equatable {
    public var status: String
    public var code: Int
    public var error: String?
    public var data: T?
    
    public init(status: String, code: Int, error: String? = nil, data: T? = nil) {
        self.status = status
        self.code = code
        self.error = error
        self.data = data
    }
    
    public static func == (lhs: BaseResponse<T>, rhs: BaseResponse<T>) -> Bool {
        return lhs.status == rhs.status && lhs.code == rhs.code && lhs.error == rhs.error && lhs.data == rhs.data
    }
    
    public enum CodingKeys: String, CodingKey {
        case status = "status"
        case code = "code"
        case error = "error"
        case data = "data"
    }
}


// MARK: - BaseResponse
public struct BaseResponseAnother<T: Codable>: Codable, Equatable where T: Equatable {
    public var success: Bool
    public var statusCode: Int
    public var message: String
    public var data: T?
    
    public init(success: Bool, statusCode: Int, message: String, data: T? = nil) {
        self.success = success
        self.statusCode = statusCode
        self.message = message
        self.data = data
    }
    
    public static func == (lhs: BaseResponseAnother<T>, rhs: BaseResponseAnother<T>) -> Bool {
        return lhs.success == rhs.success && lhs.statusCode == rhs.statusCode && lhs.message == rhs.message && lhs.data == rhs.data
    }
    
    public enum CodingKeys: String, CodingKey {
        case success = "success"
        case statusCode = "status_code"
        case message = "message"
        case data = "data"
    }
}
