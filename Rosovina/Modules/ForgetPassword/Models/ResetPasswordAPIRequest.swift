//
//  ResetPasswordAPIRequest.swift
//  Teseppas Loylaty
//
//  Created by Amir Ahmed on 13/07/2022.
//

import Foundation

// MARK: - ResetPasswordAPIRequest
struct ResetPasswordAPIRequest: Codable {
    let phone, email: String?
    let newPassword: String
    
    init(phone: String? = nil, email: String? = nil, newPassword: String){
        self.phone = phone
        self.email = email
        self.newPassword = newPassword
    }

    enum CodingKeys: String, CodingKey {
        case phone
        case email
        case newPassword = "new_password"
    }
}
