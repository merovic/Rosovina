//
//  GetSlotsAPIResponse.swift
//  Rosovina
//
//  Created by Amir Ahmed on 20/02/2024.
//

import Foundation

// MARK: - GetSlotsAPIResponseElement
struct GetSlotsAPIResponseElement: Codable, Identifiable {
    let id: Int
    let text: String
}

typealias GetSlotsAPIResponse = [GetSlotsAPIResponseElement]

extension GetSlotsAPIResponseElement: Equatable {}
