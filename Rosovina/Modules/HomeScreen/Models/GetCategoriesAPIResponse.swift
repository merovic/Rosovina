//
//  GetCategoriesAPIResponse.swift
//  Rosovina
//
//  Created by Amir Ahmed on 20/01/2024.
//

import Foundation

// MARK: - GetCategoriesAPIResponse
struct GetCategoriesAPIResponse: Codable {
    let data: [Category]
}

extension GetCategoriesAPIResponse: Equatable {}

// MARK: - Category
struct Category: Codable, Identifiable {
    let id: Int
    let slug: String
    let showInHome: Int
    let imagePath: String
    let thumbURL: String
    let title, description: String
    let isActive: Bool

    enum CodingKeys: String, CodingKey {
        case id
        case slug
        case showInHome = "show_in_home"
        case imagePath = "image_path"
        case thumbURL = "thumb_url"
        case title, description
        case isActive = "is_active"
    }
}

extension Category: Equatable {}
