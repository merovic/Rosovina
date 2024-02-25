//
//  GetUserWalletAPIResponse.swift
//  Rosovina
//
//  Created by Amir Ahmed on 23/02/2024.
//

import Foundation

// MARK: - GetUserWalletAPIResponse
struct GetUserWalletAPIResponse: Codable {
    let id, userID, balance: Int

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case balance
    }
}

extension GetUserWalletAPIResponse: Equatable {}
