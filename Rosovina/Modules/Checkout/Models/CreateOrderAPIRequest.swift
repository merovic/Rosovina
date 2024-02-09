//
//  CreateOrderAPIRequest.swift
//  Rosovina
//
//  Created by Amir Ahmed on 05/01/2024.
//

import Foundation

// MARK: - CreateOrderAPIRequest
struct CreateOrderAPIRequest: Codable {
    let mobileToken: String

    enum CodingKeys: String, CodingKey {
        case mobileToken = "device_token"
    }
}

