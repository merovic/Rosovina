//
//  WishlistAPIRequest.swift
//  Rosovina
//
//  Created by Amir Ahmed on 03/01/2024.
//

import Foundation

// MARK: - WishlistAPIRequest
struct WishlistAPIRequest: Codable {
    let deviceToken: String
    let productID: Int

    enum CodingKeys: String, CodingKey {
        case deviceToken = "device_token"
        case productID = "product_id"
    }
}

