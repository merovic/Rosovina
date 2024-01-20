//
//  AddReviewAPIRequest.swift
//  Rosovina
//
//  Created by Amir Ahmed on 20/01/2024.
//

import Foundation

// MARK: - AddReviewAPIRequest
struct AddReviewAPIRequest: Codable {
    let userID, productID, rate: Int
    let comment: String
    
    init(productID: Int, rate: Int, comment: String) {
        self.userID = Int(LoginDataService.shared.getID()) ?? 1
        self.productID = productID
        self.rate = rate
        self.comment = comment
    }

    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case productID = "product_id"
        case rate, comment
    }
}

