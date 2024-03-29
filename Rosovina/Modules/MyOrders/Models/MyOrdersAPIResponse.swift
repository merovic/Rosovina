//
//  MyOrdersAPIResponse.swift
//  Rosovina
//
//  Created by Amir Ahmed on 06/01/2024.
//

import Foundation

// MARK: - MyOrdersAPIResponse
struct MyOrder: Codable, Identifiable {
    let id, statusID: Int
    let status, estimateDeliveryTime: String
    let customerID, vendorID, parentOrderID: Int
    let code: String
    let itemsCount, itemsQuantity: Int
    let currencyCode: String
    let isGuest: Bool
    let paymentMethodID: Int
    let paymentMethodName: String
    let subTotal, discountAmount, total: Int
    let discountPercentage: Double
    let createdAt: String
    let items: [MyOrderItem]
    let activities: [Activity]
    let shippingAddress: OrderShippingAddress
    
    var formattedDate: String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-DD HH:mm:ss"
        
        let date = dateFormatter.date(from: createdAt)!
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let formattedDate = dateFormatter.string(from: date)
        return formattedDate
    }
    
    var formattedTime: String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-DD HH:mm:ss"
        
        let date = dateFormatter.date(from: createdAt)!
        dateFormatter.dateFormat = "hh:mm a"
        let formattedDate = dateFormatter.string(from: date)
        return formattedDate
    }

    enum CodingKeys: String, CodingKey {
        case id
        case statusID = "status_id"
        case status
        case estimateDeliveryTime = "estimate_delivery_time"
        case customerID = "customer_id"
        case vendorID = "vendor_id"
        case parentOrderID = "parent_order_id"
        case paymentMethodID = "payment_method_id"
        case paymentMethodName = "payment_method_name"
        case code
        case itemsCount = "items_count"
        case itemsQuantity = "items_quantity"
        case currencyCode = "currency_code"
        case isGuest = "is_guest"
        case subTotal = "sub_total"
        case discountPercentage = "discount_percentage"
        case discountAmount = "discount_amount"
        case total
        case createdAt = "created_at"
        case items, activities
        case shippingAddress = "shipping_address"
    }
}

typealias MyOrdersAPIResponse = [MyOrder]

extension MyOrder: Equatable {}

// MARK: - Activity
struct Activity: Codable {
    let id, statusID: Int
    let status: String
    let activityType: Int
    let createdAt: String
    
    var formattedDate: String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        let date = dateFormatter.date(from: createdAt)!
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let formattedDate = dateFormatter.string(from: date)
        return formattedDate
    }
    
    var formattedTime: String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        let date = dateFormatter.date(from: createdAt)!
        dateFormatter.dateFormat = "hh:mm a"
        let formattedDate = dateFormatter.string(from: date)
        return formattedDate
    }

    enum CodingKeys: String, CodingKey {
        case id
        case statusID = "status_id"
        case status
        case activityType = "activity_type"
        case createdAt = "created_at"
    }
}

extension Activity: Equatable {}

// MARK: - Item
struct MyOrderItem: Codable, Identifiable {
    let id, productID, attributeValueID, vendorID: Int
    let productName, sku, imageURL, notes: String
    let unitPrice, quantity, taxPercentage, taxAmount: Int
    let discountPercentage: Double
    let currencyCode: String?
    let discountAmount, priceAfterDiscount, total: Int

    enum CodingKeys: String, CodingKey {
        case id
        case productID = "product_id"
        case attributeValueID = "attribute_value_id"
        case vendorID = "vendor_id"
        case productName = "product_name"
        case sku
        case currencyCode = "currency_code"
        case imageURL = "image_url"
        case notes
        case unitPrice = "unit_price"
        case quantity
        case taxPercentage = "tax_percentage"
        case taxAmount = "tax_amount"
        case discountPercentage = "discount_percentage"
        case discountAmount = "discount_amount"
        case priceAfterDiscount = "price_after_discount"
        case total
    }
}

extension MyOrderItem: Equatable {}

// MARK: - ShippingAddress
struct OrderShippingAddress: Codable {
    let customerAddressID: Int
    let address, customerName, phone, phoneCountryCode: String
    let email: String
    let countryID: Int
    let countryName: String
    let cityID: Int
    let cityName: String
    let areaID: Int
    let areaName, buildingNo, flatNo, floorNo: String
    let postalCode, notes: String

    enum CodingKeys: String, CodingKey {
        case customerAddressID = "customer_address_id"
        case address
        case customerName = "customer_name"
        case phone
        case phoneCountryCode = "phone_country_code"
        case email
        case countryID = "country_id"
        case countryName = "country_name"
        case cityID = "city_id"
        case cityName = "city_name"
        case areaID = "area_id"
        case areaName = "area_name"
        case buildingNo = "building_no"
        case flatNo = "flat_no"
        case floorNo = "floor_no"
        case postalCode = "postal_code"
        case notes
    }
}

extension OrderShippingAddress: Equatable {}
