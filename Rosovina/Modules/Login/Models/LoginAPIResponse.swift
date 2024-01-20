//
//  LoginAPIResponse.swift
//  Teseppas Loylaty
//
//  Created by Amir Ahmed on 13/07/2022.
//

import Foundation

// MARK: - LoginAPIResponse
struct LoginAPIResponse: Codable {
    let userInfo: UserInfo
    let token: String
}

extension LoginAPIResponse: Equatable {}
