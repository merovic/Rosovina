//
//  GetGiftCardsAPIResponse.swift
//  Rosovina
//
//  Created by Amir Ahmed on 18/01/2024.
//

import Foundation

// MARK: - GiftCard
struct GiftCard: Codable, Identifiable {
    let id: Int
    let imagePath: String

    enum CodingKeys: String, CodingKey {
        case id
        case imagePath = "image_path"
    }
}

extension GiftCard: Equatable {}

typealias GetGiftCardsAPIResponse = [GiftCard]
