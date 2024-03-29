//
//  UpdateCartAPIRequest.swift
//  Rosovina
//
//  Created by Amir Ahmed on 01/01/2024.
//

import Foundation
import UIKit

// MARK: - UpdateCartAPIRequest
struct UpdateCartAPIRequest: Codable {
    let addressID: Int?
    let deviceToken: String
    let cityID: Int = LoginDataService.shared.getUserCity().id
    let promoCodeID: Int?
    let receiverName: String?
    let receiverPhone: String?
    let customize: Customize?
    let items: [APICartItem]?
    
    init(addressID: Int? = nil, promoCodeID: Int? = nil, receiverName: String? = nil, receiverPhone: String? = nil, customize: Customize? = nil, items: [APICartItem]? = nil) {
        self.addressID = addressID
        self.deviceToken = UIDevice.current.identifierForVendor!.uuidString
        self.promoCodeID = promoCodeID
        self.receiverName = receiverName
        self.receiverPhone = receiverPhone
        self.customize = customize
        self.items = items
    }

    enum CodingKeys: String, CodingKey {
            case addressID = "address_id"
            case deviceToken = "device_token"
            case promoCodeID = "promo_code_id"
            case receiverName = "receiver_name"
            case receiverPhone = "receiver_phone"
            case customize, items
            case cityID = "city_id"
        }
}

// MARK: - Customize
struct Customize: Codable {
    let cardID: Int
    let to, message: String
    let feelingLink: String

    enum CodingKeys: String, CodingKey {
        case cardID = "card_id"
        case to, message
        case feelingLink = "feeling_link"
    }
}

// MARK: - Item
struct APICartItem: Codable {
    let productID, quantity: Int
    let attributeValueIDS: [Int]

    enum CodingKeys: String, CodingKey {
        case productID = "product_id"
        case quantity
        case attributeValueIDS = "attribute_value_ids"
    }
}

