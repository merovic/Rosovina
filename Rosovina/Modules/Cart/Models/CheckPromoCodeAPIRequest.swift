//
//  CheckPromoCodeAPIRequest.swift
//  Rosovina
//
//  Created by Amir Ahmed on 19/01/2024.
//

import Foundation

// MARK: - CheckPromoCodeAPIRequest
struct CheckPromoCodeAPIRequest: Codable {
    let code: String
    let amount: Int
}

