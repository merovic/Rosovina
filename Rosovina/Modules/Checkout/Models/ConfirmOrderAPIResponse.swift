//
//  ConfirmOrderAPIResponse.swift
//  Rosovina
//
//  Created by Amir Ahmed on 02/02/2024.
//

import Foundation

// MARK: - ConfirmOrderAPIResponse
struct ConfirmOrderAPIResponse: Codable {
    let orderID: Int

    enum CodingKeys: String, CodingKey {
        case orderID = "order_id"
    }
}

extension ConfirmOrderAPIResponse: Equatable {}
