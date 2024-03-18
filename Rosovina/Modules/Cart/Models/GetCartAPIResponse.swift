//
//  GetCartAPIResponse.swift
//  Rosovina
//
//  Created by Amir Ahmed on 01/01/2024.
//

import Foundation

// MARK: - GetCartAPIResponse
struct GetCartAPIResponse: Codable {
    let id: Int
    let currencyCode: String
    let subTotal, total, discountPercentage, itemsCount: Int
    let itemsQuantity: Int
    let addressID: Int?
    let deliveryFee: Int
    let address: UserAddress?
    var items: [CartItem]

    enum CodingKeys: String, CodingKey {
        case id
        //case customerID = "customer_id"
        case currencyCode = "currency_code"
        case subTotal = "sub_total"
        case total
        case discountPercentage = "discount_percentage"
        case itemsCount = "items_count"
        case itemsQuantity = "items_quantity"
        case addressID = "address_id"
        case deliveryFee = "delivery_fee"
        case address
        case items
    }
}

extension GetCartAPIResponse: Equatable {}

// MARK: - Item
struct CartItem: Codable, Identifiable {
    var id = UUID().uuidString
    let productID: Int
    let productAttributeValueID: Int?
    let productName: String
    let sku: String?
    let notes: String?
    let currencyCode: String?
    let productImage: String
    var quantity: String
    let couponCode, taxPercentage: String
    let taxAmount, discountAmount, priceAfterDiscount: Int
    let unitPrice, total: Int
    let itemAttributeValues: [ItemAttributeValue]

    enum CodingKeys: String, CodingKey {
        case productID = "product_id"
        case productAttributeValueID = "product_attribute_value_id"
        case productName = "product_name"
        case notes
        case sku
        case currencyCode = "currency_code"
        case productImage = "product_image"
        case couponCode = "coupon_code"
        case unitPrice = "unit_price"
        case quantity
        case taxPercentage = "tax_percentage"
        case taxAmount = "tax_amount"
        //case discountPercentage = "discount_percentage"
        case discountAmount = "discount_amount"
        case priceAfterDiscount = "price_after_discount"
        case total, itemAttributeValues
    }
}

extension CartItem: Equatable {}

// MARK: - ItemAttributeValue
struct ItemAttributeValue: Codable {
    let id, cartItemID, productAttributeValueID, total: Int
    let title: String

    enum CodingKeys: String, CodingKey {
        case id
        case cartItemID = "cart_item_id"
        case productAttributeValueID = "product_attribute_value_id"
        case title, total
    }
}

extension ItemAttributeValue: Equatable {}
