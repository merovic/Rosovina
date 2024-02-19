//
//  GeoLocationAPIResponse.swift
//  Rosovina
//
//  Created by Amir Ahmed on 04/01/2024.
//

import Foundation

// MARK: - GeoLocationAPIResponseElement
struct GeoLocationAPIResponseElement: Codable, Identifiable {
    let id: Int
    let name: String
    let image_path: String?
}

extension GeoLocationAPIResponseElement: Equatable {}

typealias GeoLocationAPIResponse = [GeoLocationAPIResponseElement]
