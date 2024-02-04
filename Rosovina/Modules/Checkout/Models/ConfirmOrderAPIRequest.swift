//
//  ConfirmOrderAPIRequest.swift
//  Rosovina
//
//  Created by Amir Ahmed on 01/02/2024.
//

import Foundation

// MARK: - ConfirmOrderAPIRequest
struct ConfirmOrderAPIRequest: Codable {
    let deviceToken: String
    let orderID, paymentMethodID: Int
    let paymentReference: String

    enum CodingKeys: String, CodingKey {
        case deviceToken = "device_token"
        case orderID = "order_id"
        case paymentMethodID = "payment_method_id"
        case paymentReference = "payment_reference"
    }
}
