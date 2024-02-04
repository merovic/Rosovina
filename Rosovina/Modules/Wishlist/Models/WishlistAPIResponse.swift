//
//  WishlistAPIResponse.swift
//  Rosovina
//
//  Created by Amir Ahmed on 03/01/2024.
//

import Foundation

// MARK: - WishlistAPIResponse
struct WishlistAPIResponse: Codable {
    let id, customerID: Int
    let items: [WishlistItem]

    enum CodingKeys: String, CodingKey {
        case id
        case customerID = "customer_id"
        case items
    }
}

extension WishlistAPIResponse: Equatable {}

// MARK: - Item
struct WishlistItem: Codable, Identifiable {
    var id = UUID().uuidString
    let productID: Int
    let productName, productDescription, unitCode: String
    let isInStock: Int
    let currencyCode: String?
    let price: Double
    let productImage: String

    enum CodingKeys: String, CodingKey {
        case productID = "product_id"
        case productName = "product_name"
        case productDescription = "product_description"
        case unitCode = "unit_code"
        case isInStock = "is_in_stock"
        case price
        case currencyCode = "currency_code"
        case productImage = "product_image"
    }
}

extension WishlistItem: Equatable {}
