//
//  LoginAPIRequest.swift
//  Teseppas Loylaty
//
//  Created by Amir Ahmed on 12/07/2022.
//

import Foundation
import UIKit

// MARK: - LoginAPIRequest
struct LoginAPIRequest: Codable {
    let phone, password: String
    let platform, ipAddress: String
    let osVersion, mobileBrand: String
    let mobileToken: String
    
    init(phone: String, password:String, mobileToken: String){
        self.phone = phone
        self.password = password
        self.platform = "iOS"
        self.ipAddress = "192.168.1.1"
        self.osVersion = "iOS " + UIDevice.current.systemVersion
        self.mobileBrand = UIDevice.modelName
        self.mobileToken = mobileToken
    }

    enum CodingKeys: String, CodingKey {
        case phone, password, platform
        case ipAddress = "ip_address"
        case osVersion = "os_version"
        case mobileBrand = "mobile_brand"
        case mobileToken = "mobile_token"
    }
    
}

