//
//  PhoneAPIRequest.swift
//  Teseppas Loylaty
//
//  Created by Amir Ahmed on 13/07/2022.
//

import Foundation

// MARK: - PhoneAPIRequest
struct PhoneAPIRequest: Codable {
    let phone: String?
    let email: String?
    
    init(phone: String? = nil, email: String? = nil) {
        self.phone = phone
        self.email = email
    }
}
