//
//  TestFileNew.swift
//  Rosovina
//
//  Created by Amir Ahmed on 29/12/2023.
//

import Foundation

// MARK: - HomeAPIResponse
struct HomeAPIResponse: Codable {
    let sections: [Section]
    let general: General
}

extension HomeAPIResponse: Equatable {}

// MARK: - General
struct General: Codable {
    let cartCount: Int

    enum CodingKeys: String, CodingKey {
        case cartCount = "cart_count"
    }
}

extension General: Equatable {}

// MARK: - Section
struct Section: Codable, Identifiable {
    var id = UUID().uuidString
    let order: Int
    let code: SectionDataType
    let name, backgroundColor, backgroundImage: String
    let title, notes: String
    let data: [DynamicHomeModel]

    enum CodingKeys: String, CodingKey {
        case order, name, code
        case backgroundColor = "background_color"
        case backgroundImage = "background_image"
        case title, notes, data
    }
}

extension Section: Equatable {}

enum SectionDataType: String, Codable {
    case slider = "slider"
    case brands = "brands"
    case occasionCategories = "occasionCategories"
    case categories = "categories"
    case featuredProducts = "featuredProducts"
    case advertise = "advertise"
    case popularProducts = "popularProducts"
    case sliderAds = "sliderads"
    case newArrival = "newArrival"
}

// MARK: - DynamicHomeModel
struct DynamicHomeModel: Codable, Identifiable {
    let id: Int?
    let imagePath: String?
    let title, name, description: String?
    let listOrder: Int?
    let slug: String?
    let currencyCode: String?
    let showInHome, isOccasion, isBrand: Int?
    let imageURL: String?
    let thumbURL: String?
    let isActive: Bool?
    let unitID: Int?
    let unitCode: String?
    let isFeatured, isPopular, isNewArrival, isInStock: Int?
    var addedToWishlist: Bool?
    let sku, discountPercentage: String?
    let rate: String?
    let price: Double?
    let discountAmount: Int?
    let isReadyForSale: Int?
    let isReadyForSaleText: String?

    enum CodingKeys: String, CodingKey {
        case id
        case imagePath = "image_path"
        case title, name, description
        case listOrder = "list_order"
        case slug
        case currencyCode = "currency_code"
        case showInHome = "show_in_home"
        case isOccasion = "is_occasion"
        case isBrand = "is_brand"
        case imageURL = "image_url"
        case thumbURL = "thumb_url"
        case isActive = "is_active"
        case unitID = "unit_id"
        case unitCode = "unit_code"
        case isFeatured = "is_featured"
        case isPopular = "is_popular"
        case isNewArrival = "is_new_arrival"
        case isInStock = "is_in_stock"
        case addedToWishlist = "added_to_wishlist"
        case sku, rate, price
        case discountAmount = "discount_amount"
        case discountPercentage = "discount_percentage"
        case isReadyForSale = "is_ready_for_sale"
        case isReadyForSaleText = "is_ready_for_sale_text"
    }
}

extension DynamicHomeModel: Equatable {}
