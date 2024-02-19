//
//  CheckPromoCodeAPIResponse.swift
//  Rosovina
//
//  Created by Amir Ahmed on 19/01/2024.
//

import Foundation

// MARK: - CheckPromoCodeAPIResponse
struct CheckPromoCodeAPIResponse: Codable {
    let id: Int
    let discountPercentage: String?
    let discountAmount: Int
    let code: String
    let bandwidth, userUsage: Int
    let startsIn, dueDate, minimumOrderPrice, maxDiscountAmount: String
    let createdBy: String?
    let isActive: Int
    let createdAt, updatedAt: String

    enum CodingKeys: String, CodingKey {
        case id
        case discountPercentage = "discount_percentage"
        case discountAmount = "discount_amount"
        case code, bandwidth
        case userUsage = "user_usage"
        case startsIn = "starts_in"
        case dueDate = "due_date"
        case minimumOrderPrice = "minimum_order_price"
        case maxDiscountAmount = "max_discount_amount"
        case createdBy = "created_by"
        case isActive = "is_active"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

extension CheckPromoCodeAPIResponse: Equatable {}
