//
//  ProductDetailsAPIResponse.swift
//  Rosovina
//
//  Created by Amir Ahmed on 31/12/2023.
//

import Foundation

// MARK: - ProductDetailsAPIResponse
struct ProductDetailsAPIResponse: Codable {
    let id: Int
    let listOrder: Int?
    let slug: String
    let showInHome, isFeatured, isPopular, isNewArrival: Int
    let isInStock: Int
    let addedToWishlist: Bool?
    let sku: String
    let rate: String?
    let imageURL: String
    let title, description, additionalInfo: String
    let price, discountAmount: Int
    let discountPercentage: String
    let isActive: Bool
    let variants: [Variant]
    let images: [String]
    let reviews: [Review]

    enum CodingKeys: String, CodingKey {
        case id
        case listOrder = "list_order"
        case slug
        case showInHome = "show_in_home"
        case isFeatured = "is_featured"
        case isPopular = "is_popular"
        case isNewArrival = "is_new_arrival"
        case isInStock = "is_in_stock"
        case addedToWishlist = "added_to_wishlist"
        case sku, rate
        case imageURL = "image_url"
        case title, description
        case additionalInfo = "additional_info"
        case price
        case reviews
        case discountAmount = "discount_amount"
        case discountPercentage = "discount_percentage"
        case isActive = "is_active"
        case variants, images
    }
}

extension ProductDetailsAPIResponse: Equatable {}

// MARK: - Variant
struct Variant: Codable {
    let id: Int
    let title: String?
    let isOptional, isExtra: Bool
    let attributeValues: [AttributeValue]

    enum CodingKeys: String, CodingKey {
        case id, title
        case isOptional = "is_optional"
        case isExtra = "is_extra"
        case attributeValues = "attribute_values"
    }
}

extension Variant: Equatable {}

// MARK: - AttributeValue
struct AttributeValue: Codable {
    let id: Int
    let title, originalPrice, discountPercentage, discountAmount: String
    let taxPercentage, taxAmount, price: String
    let isActive: Bool

    enum CodingKeys: String, CodingKey {
        case id, title
        case originalPrice = "original_price"
        case discountPercentage = "discount_percentage"
        case discountAmount = "discount_amount"
        case taxPercentage = "tax_percentage"
        case taxAmount = "tax_amount"
        case price
        case isActive = "is_active"
    }
}

extension AttributeValue: Equatable {}

// MARK: - Review
struct Review: Codable, Identifiable {
    let id: Int
    let comment: String
    let rate: Int
    let userName: String
    let userImage: String

    enum CodingKeys: String, CodingKey {
        case id, comment, rate
        case userName = "user_name"
        case userImage = "user_image"
    }
}

extension Review: Equatable {}
