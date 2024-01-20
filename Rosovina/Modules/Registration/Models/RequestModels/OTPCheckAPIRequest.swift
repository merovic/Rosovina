//
//  OTPCheckAPIRequest.swift
//  Teseppas Loylaty
//
//  Created by Amir Ahmed on 12/07/2022.
//

import Foundation

// MARK: - OTPCheckAPIRequest
struct OTPCheckAPIRequest: Codable {
    let phone, otp: String
}
