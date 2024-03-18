//
//  CreateOrderAPIRequest.swift
//  Rosovina
//
//  Created by Amir Ahmed on 05/01/2024.
//

import Foundation

// MARK: - CreateOrderAPIRequest
struct CreateOrderAPIRequest: Codable {
    let mobileToken: String
    let slotID: Int
    let slotDate: String
    let slotText: String
    let cityID: Int = LoginDataService.shared.getUserCity().id

    enum CodingKeys: String, CodingKey {
        case mobileToken = "device_token"
        case slotID = "slot_id"
        case slotDate = "slot_date"
        case slotText = "slot_text"
        case cityID = "city_id"
    }
}

