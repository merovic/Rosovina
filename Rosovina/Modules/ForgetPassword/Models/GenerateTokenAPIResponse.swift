//
//  generateTokenResponse.swift
//  Wever
//
//  Created by Apple on 08/06/2021.
//

import Foundation

// MARK: - DataClass
struct GenerateTokenAPIResponse: Codable {
    let token: String

    enum CodingKeys: String, CodingKey {
        case token = "token"
    }
}

extension GenerateTokenAPIResponse: Equatable {}
