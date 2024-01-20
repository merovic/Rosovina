//
//  OTPSendAPIResponse.swift
//  Teseppas Loylaty
//
//  Created by Amir Ahmed on 13/07/2022.
//

import Foundation

// MARK: - OTPSendAPIResponse
struct OTPSendAPIResponse: Codable {
    let type, msg: String
    let data: DataClass
}

// MARK: - DataClass
struct DataClass: Codable {
    let smsid: String
    let sent, failed: Int
    let reciver: String
}
