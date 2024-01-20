//
//  RegistrationAPIResponse.swift
//  Rosovina
//
//  Created by Amir Ahmed on 20/12/2023.
//

import Foundation

// MARK: - RegistrationAPIResponse
struct RegistrationAPIResponse: Codable {
    let userInfo: UserInfo
    let token: String
}

extension RegistrationAPIResponse: Equatable {}

// MARK: - UserInfo
struct UserInfo: Codable {
    let id, userTypeID: Int
    let name, code, email, mobileToken: String
    let imageURL: String
    let phone: String
    let dateOfBirth: String?
    let lang: String

    enum CodingKeys: String, CodingKey {
        case id
        case userTypeID = "user_type_id"
        case name, code, email
        case mobileToken = "mobile_token"
        case imageURL = "image_url"
        case phone
        case dateOfBirth = "date_of_birth"
        case lang
    }
}

extension UserInfo: Equatable {}
