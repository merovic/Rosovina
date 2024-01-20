//
//  CreateOrderAPIRequest.swift
//  Rosovina
//
//  Created by Amir Ahmed on 05/01/2024.
//

import Foundation

// MARK: - CreateOrderAPIRequest
struct CreateOrderAPIRequest: Codable {
    let mobileToken, promoCode: String

    enum CodingKeys: String, CodingKey {
        case mobileToken = "mobile_token"
        case promoCode = "promo_code"
    }
}

