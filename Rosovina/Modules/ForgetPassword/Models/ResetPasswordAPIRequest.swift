//
//  ResetPasswordAPIRequest.swift
//  Teseppas Loylaty
//
//  Created by Amir Ahmed on 13/07/2022.
//

import Foundation

// MARK: - ResetPasswordAPIRequest
struct ResetPasswordAPIRequest: Codable {
    let phone, newPassword: String
    
    init(phone: String, newPassword: String){
        self.phone = phone
        self.newPassword = newPassword
    }

    enum CodingKeys: String, CodingKey {
        case phone
        case newPassword = "new_password"
    }
}
