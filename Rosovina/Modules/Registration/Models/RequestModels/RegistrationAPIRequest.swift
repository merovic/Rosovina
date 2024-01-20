//
//  RegistrationAPIRequest.swift
//  Teseppas Loylaty
//
//  Created by Amir Ahmed on 12/07/2022.
//

import Foundation
import UIKit
import MOLH

// MARK: - RegistrationAPIRequest
struct RegistrationAPIRequest: Codable {
    let name, phone, password, platform: String
    let email, ipAddress, osVersion: String
    let mobileBrand, lang, mobileToken: String
    
    init(name: String, phone: String, password:String, email:String, mobileToken: String){
        self.name = name
        self.phone = phone
        self.password = password
        self.email = email
        self.platform = "iOS"
        self.lang = MOLHLanguage.isRTLLanguage() ? "ar" : "en"
        self.ipAddress = "192.168.1.1"
        self.osVersion = "iOS " + UIDevice.current.systemVersion
        self.mobileBrand = UIDevice.modelName
        self.mobileToken = mobileToken
    }

    enum CodingKeys: String, CodingKey {
            case name, phone, password, platform, email
            case ipAddress = "ip_address"
            case osVersion = "os_version"
            case mobileBrand = "mobile_brand"
            case lang
            case mobileToken = "mobile_token"
        }
}
