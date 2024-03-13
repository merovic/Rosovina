//
//  BrandsAPIResponse.swift
//  Rosovina
//
//  Created by Amir Ahmed on 08/03/2024.
//

import Foundation

// MARK: - BrandsAPIResponseElement
struct Brand: Codable, Identifiable {
    let id: Int
    let slug: String
    let imagePath, logoPath: String
    let name, description: String
    let listOrder: Int
    let isActive: Bool
    let isBrand: Int

    enum CodingKeys: String, CodingKey {
        case id, slug
        case imagePath = "image_path"
        case logoPath = "logo_path"
        case name, description
        case listOrder = "list_order"
        case isActive = "is_active"
        case isBrand = "is_brand"
    }
}

extension Brand: Equatable {}

typealias BrandsAPIResponse = [Brand]

