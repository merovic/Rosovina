//
//  UpdateAccountAPIResponse.swift
//  Rosovina
//
//  Created by Amir Ahmed on 20/01/2024.
//

import Foundation

// MARK: - UpdateAccountAPIResponse
struct UpdateAccountAPIResponse: Codable {
    let id: Int
    let name, email: String
    let phone: String
    let lang, platform, imageURL: String

    enum CodingKeys: String, CodingKey {
        case id, name, email
        case phone
        case lang, platform
        case imageURL = "image_url"
    }
}

extension UpdateAccountAPIResponse: Equatable {}
