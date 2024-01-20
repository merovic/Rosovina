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
    //let meta: Meta
}

extension GetProductsAPIResponse: Equatable {}

// MARK: - Product
struct Product: Codable, Identifiable {
    let id, unitID: Int
    let unitCode: String
    let listOrder: Int?
    let slug: String
    let showInHome, isFeatured, isPopular, isNewArrival: Int
    let isInStock: Int
    let addedToWishlist: Bool?
    let sku: String
    let rate: String?
    let imagePath: String
    let title, description: String
    let price: Double
    let discountAmount, discountPercentage: String
    let isActive: Bool

    enum CodingKeys: String, CodingKey {
        case id
        case unitID = "unit_id"
        case unitCode = "unit_code"
        case listOrder = "list_order"
        case slug
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
    }
}

extension Product: Equatable {}

// MARK: - Meta
struct Meta: Codable {
    let currentPage, from, lastPage: Int
    let path: String
    let perPage, to, total: Int

    enum CodingKeys: String, CodingKey {
        case currentPage = "current_page"
        case from
        case lastPage = "last_page"
        case path
        case perPage = "per_page"
        case to, total
    }
}

extension Meta: Equatable {}

// MARK: - Link
struct Link: Codable {
    let url: String?
    let label: String
    let active: Bool
}

extension Link: Equatable {}
