//
//  OTPCheckAPIResponse.swift
//  Teseppas Loylaty
//
//  Created by Amir Ahmed on 13/07/2022.
//

import Foundation

// MARK: - OTPCheckAPIResponse
struct OTPCheckAPIResponse: Codable {
    let type: String
    var msg: String? = nil
    var error: OTPError? = nil
    let data: String
}

// MARK: - Error
struct OTPError: Codable {
    let msg: String
    let number: Int
}
