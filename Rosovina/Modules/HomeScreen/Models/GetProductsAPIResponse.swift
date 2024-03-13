//
//  GetProductsAPIResponse.swift
//  Rosovina
//
//  Created by Amir Ahmed on 03/01/2024.
//

import Foundation

// MARK: - GetProductsAPIResponse
struct GetProductsAPIResponse: Codable {
    let data: [Product]
    let meta: Meta?
}

extension GetProductsAPIResponse: Equatable {}

// MARK: - Product
struct Product: Codable, Identifiable {
    let id, unitID: Int
    let unitCode: String
    let listOrder: Int?
    let slug: String
    let currencyCode: String?
    let showInHome, isFeatured, isPopular, isNewArrival: Int?
    let isInStock: Int
    let addedToWishlist: Bool?
    let sku: String
    let rate: String?
    let imagePath, discountPercentage: String
    let title, description: String
    let price: Double
    let discountAmount: Int
    let isActive: Bool
    let isReadyForSale: Int
    let isReadyForSaleText: String?

    enum CodingKeys: String, CodingKey {
        case id
        case unitID = "unit_id"
        case unitCode = "unit_code"
        case listOrder = "list_order"
        case slug
        case currencyCode = "currency_code"
        case showInHome = "show_in_home"
        case isFeatured = "is_featured"
        case isPopular = "is_popular"
        case isNewArrival = "is_new_arrival"
        case isInStock = "is_in_stock"
        case addedToWishlist = "added_to_wishlist"
        case sku, rate
        case imagePath = "image_path"
        case title, description, price
        case discountAmount = "discount_amount"
        case discountPercentage = "discount_percentage"
        case isActive = "is_active"
        case isReadyForSale = "is_ready_for_sale"
        case isReadyForSaleText = "is_ready_for_sale_text"
    }
}

extension Product: Equatable {}

// MARK: - Meta
struct Meta: Codable {
    let to, currentPage, lastPage, from: Int
    let perPage, total: Int
    let path: String

    enum CodingKeys: String, CodingKey {
        case to
        case currentPage = "current_page"
        case lastPage = "last_page"
        case from
        case perPage = "per_page"
        case total, path
    }
}

extension Meta: Equatable {}
