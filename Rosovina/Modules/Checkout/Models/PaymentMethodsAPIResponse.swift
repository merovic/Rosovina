//
//  PaymentMethodsAPIResponse.swift
//  Rosovina
//
//  Created by Amir Ahmed on 23/03/2024.
//

import Foundation

// MARK: - PaymentMethodItem
struct PaymentMethodItem: Codable, Identifiable {
    let id: Int
    let code, name, description: String
    let sort: Int
    let imagePath: String
    
    var paymentMethod: PaymentMethodEnum {
        switch id {
        case 1: return .CreditCard
        case 3: return .Tamara
        case 5: return .ApplePay
        default: return .CreditCard
        }
    }

    enum CodingKeys: String, CodingKey {
        case id, code, name, description, sort
        case imagePath = "image_path"
    }
}

typealias PaymentMethodsAPIResponse = [PaymentMethodItem]

extension PaymentMethodItem: Equatable {}


enum PaymentMethodEnum {
    case CreditCard,
         ApplePay,
         Tamara,
         Tabby,
         STCPay

    var title: String {
        switch self {
        case .CreditCard: return "Credit Card"
        case .ApplePay: return "Apple Pay"
        case .Tamara: return "Tamara"
        case .Tabby: return "Tabby"
        case .STCPay: return "STC Pay"
        }
    }

    var image: String {
        switch self {
        case .CreditCard: return "card"
        case .ApplePay: return "applepayblack"
        case .Tamara: return "tamara"
        case .Tabby: return ""
        case .STCPay: return ""
        }
    }
}
