//
//  File.swift
//  Rosovina
//
//  Created by Amir Ahmed on 23/02/2024.
//

import Foundation

// MARK: - GetUserTransactionsAPIResponseElement
struct UserTransaction: Codable, Identifiable {
    let id, amount: Int
    let type, description: String
}

extension UserTransaction: Equatable {}

typealias GetUserTransactionsAPIResponse = [UserTransaction]

