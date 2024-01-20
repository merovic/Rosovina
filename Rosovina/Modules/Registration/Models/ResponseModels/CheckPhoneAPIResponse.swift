//
//  CheckPhoneAPIResponse.swift
//  Teseppas Loylaty
//
//  Created by Amir Ahmed on 14/07/2022.
//

import Foundation

struct CheckPhoneAPIResponse: Codable {
    let success: Bool
    let statusCode: Int
    let message: String
    let data: [String]?

    enum CodingKeys: String, CodingKey {
        case success
        case statusCode = "status_code"
        case message
        case data
    }
}
